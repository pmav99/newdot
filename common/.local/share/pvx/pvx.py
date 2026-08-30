import os

from paraview import servermanager
from paraview.simple import GetActiveView, GetRenderViews, GetSources, OpenDataFile, RenameSource
from vtkmodules.util.misc import calldata_type
from vtkmodules.vtkCommonCore import VTK_INT, vtkCommand


DEBUG = os.environ.get("PVX_DEBUG") == "1"


def debug(*args):
    if DEBUG:
        print("pvx:", *args)


# Command-line inputs

def wrapper_inputs():
    """Return NUL-separated input paths supplied by the wrapper."""
    path = os.environ.get("PVX_INPUTS_FILE")
    if not path:
        return []

    with open(path, "rb") as handle:
        payload = handle.read()

    return [os.fsdecode(part) for part in payload.split(b"\0") if part]


def pipeline_name(filename, seen):
    """Return a unique Pipeline Browser name for filename."""
    name = os.path.basename(filename) or filename

    seen[name] = seen.get(name, 0) + 1

    if seen[name] == 1:
        return name

    return f"{name} ({seen[name]})"


def view_id(view):
    return view.SMProxy.GetGlobalIDAsString()


# Pipeline Browser synchronization

def first_visible_source_in_view(view):
    """Return the first visible pipeline source in view, if any."""
    for key, source in GetSources().items():
        try:
            representation = servermanager.GetRepresentation(source, view)

            if representation is not None and bool(representation.Visibility):
                debug("visible source:", key[0], "view:", view_id(view))
                return source

        except Exception:
            continue

    return None


def select_source(source):
    """Select source in the Pipeline Browser and make it current."""
    if source is None:
        return

    try:
        proxy_manager = servermanager.ProxyManager(source.GetSession())

        model = proxy_manager.GetSelectionModel("ActiveSources")

        if model is None:
            debug("ActiveSources model not found")
            return

        sm_source = source.SMProxy

        model.ClearAndSelect(sm_source)
        model.SetCurrentProxy(sm_source, model.NO_UPDATE)

        debug("selected source:", sm_source.GetGlobalIDAsString())

    except Exception as exc:
        print("pvx: pipeline selection failed:", exc)


# Camera synchronization
#
# These correspond to the camera properties copied by vtkSMCameraLink.
#
# InteractionMode is deliberately excluded. ParaView temporarily changes
# InteractionMode during operations such as Zoom To Box; synchronizing that
# state between views interferes with the interaction.

CAMERA_PROPERTIES = (
    ("CameraPositionInfo", "CameraPosition"),
    ("CameraViewAngleInfo", "CameraViewAngle"),
    ("CameraFocalPointInfo", "CameraFocalPoint"),
    ("CameraViewUpInfo", "CameraViewUp"),
    ("CenterOfRotation", "CenterOfRotation"),
    ("CameraParallelScaleInfo", "CameraParallelScale"),
    ("RotationFactor", "RotationFactor"),
    ("CameraParallelProjection", "CameraParallelProjection"),
    ("CameraFocalDiskInfo", "CameraFocalDisk"),
    ("CameraFocalDistanceInfo", "CameraFocalDistance"),
)


camera_anchor_id = None

# view id -> (SMProxy, observer tag)
camera_observers = {}

# Prevent synchronization-triggered renders from recursively synchronizing.
camera_syncing = False


def copy_camera(source_proxy, target_proxy):
    """Copy camera state, deliberately excluding InteractionMode."""
    for source_name, target_name in CAMERA_PROPERTIES:
        try:
            source_property = source_proxy.GetProperty(source_name)

            target_property = target_proxy.GetProperty(target_name)

            if source_property is None or target_property is None:
                continue

            target_property.Copy(source_property)
            target_proxy.UpdateProperty(target_name)

        except Exception as exc:
            debug("camera property copy failed:", source_name, "->", target_name, exc)


@calldata_type(VTK_INT)
def camera_render_finished(caller, event, interactive):
    """Propagate a rendered camera to every other Render View."""
    global camera_syncing

    if camera_syncing:
        return

    camera_syncing = True

    try:
        caller_id = caller.GetGlobalIDAsString()

        for view in GetRenderViews():
            target = view.SMProxy

            if target.GetGlobalIDAsString() == caller_id:
                continue

            copy_camera(caller, target)

            if interactive:
                target.InteractiveRender()
            else:
                target.StillRender()

    except Exception as exc:
        print("pvx: camera synchronization failed:", exc)

    finally:
        camera_syncing = False


def ensure_camera_observers():
    """Keep camera observers synchronized with current Render Views."""
    global camera_anchor_id, camera_syncing

    views = list(GetRenderViews())

    current = {view_id(view): view for view in views}

    # Remove observers for deleted views.
    for old_id in list(camera_observers):
        if old_id in current:
            continue

        proxy, tag = camera_observers.pop(old_id)

        try:
            proxy.RemoveObserver(tag)
        except Exception:
            pass

        debug("removed camera observer:", old_id)

    if not views:
        camera_anchor_id = None
        return

    # Keep the oldest surviving Render View as the camera anchor.
    if camera_anchor_id not in current:
        camera_anchor_id = view_id(views[0])

        debug("camera anchor:", camera_anchor_id)

    anchor = current[camera_anchor_id].SMProxy

    new_views = []

    # Install observers on newly discovered Render Views.
    for current_id, view in current.items():
        if current_id in camera_observers:
            continue

        proxy = view.SMProxy

        tag = proxy.AddObserver(vtkCommand.EndEvent, camera_render_finished)

        camera_observers[current_id] = (proxy, tag)

        new_views.append(view)

        debug("installed camera observer:", current_id)

    # Initialize newly-created views from the anchor.
    camera_syncing = True

    try:
        for view in new_views:
            if view_id(view) == camera_anchor_id:
                continue

            copy_camera(anchor, view.SMProxy)

            debug("initialized camera:", view_id(view), "from:", camera_anchor_id)

    finally:
        camera_syncing = False


# Active-view handling


def get_active_view(caller):
    """
    Resolve the active view from the selection-model callback.

    Fall back to ParaView's normal active-view lookup if necessary.
    """
    if caller is not None:
        try:
            sm_view = caller.GetCurrentProxy()

            if sm_view is not None:
                return servermanager._getPyProxy(sm_view)

        except Exception as exc:
            debug("failed to obtain active view:", exc)

    try:
        return GetActiveView()
    except Exception:
        return None


def is_render_view(view):
    try:
        return view is not None and view.SMProxy.IsA("vtkSMRenderViewProxy")
    except Exception:
        return False


def active_view_changed(caller=None, event=None):
    """
    Maintain camera observers and synchronize Pipeline Browser selection.
    """
    try:
        ensure_camera_observers()
    except Exception as exc:
        print("pvx: camera observer update failed:", exc)

    view = get_active_view(caller)

    if not is_render_view(view):
        return

    debug("active Render View:", view_id(view))

    source = first_visible_source_in_view(view)

    if source is None:
        debug("no visible source in active view")
        return

    select_source(source)


# Create readers without displaying or rendering them.
seen_names = {}
for filename in wrapper_inputs():
    source = OpenDataFile(filename)
    RenameSource(pipeline_name(filename, seen_names), source)


# Global active-view observer

proxy_manager = servermanager.ProxyManager()

active_view_model = proxy_manager.GetSelectionModel("ActiveView")

if active_view_model is not None:
    active_view_observer = active_view_model.AddObserver(vtkCommand.CurrentChangedEvent, active_view_changed)
else:
    active_view_observer = None
    print("pvx: ActiveView selection model not found")


# Initialize existing Render Views.
#
# active_view_changed() already calls ensure_camera_observers(), so there is
# no need to call it separately here.

active_view_changed()
