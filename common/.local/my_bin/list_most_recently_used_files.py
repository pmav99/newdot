#!/usr/bin/env python3

""" Find the most recently modified file per directory (recursively) """

import argparse
import datetime
import os
import pathlib


def get_mtime(filepath):
    mtime = filepath.stat().st_mtime
    dt = datetime.datetime.fromtimestamp(mtime)
    return dt


def get_modification_times(root_dir, max_depth=None):
    data = {}
    root_level = len(root_dir.parents)
    for root, dirs, files in os.walk(root_dir):
        if files:
            root = pathlib.Path(root)
            current_level = len(root.parents)
            if max_depth and current_level - max_depth <= root_level:
                filepaths = [root / filename for filename in files]
                modification_times = {get_mtime(filepath): filepath.as_posix() for filepath in filepaths}
                most_recently_modified_timestamp = max(modification_times.keys())
                data[modification_times[most_recently_modified_timestamp]] = most_recently_modified_timestamp
    return data


def main():
    parser = argparse.ArgumentParser(
        prog="Find the most recently modified file per directory (recursively)",
        usage="python find_most_recent_files.py PATH"
    )
    parser.add_argument("root_dir", nargs='?', action="store", default="./")
    parser.add_argument("-d", "--max-depth", action="store", default=None, type=int)
    args = parser.parse_args()

    root_dir = pathlib.Path(args.root_dir).expanduser().resolve()
    if not root_dir.exists():
        raise ValueError(f"Provided root directory does not exist: {root_dir}")

    modification_times = get_modification_times(root_dir, args.max_depth)
    if not modification_times:
        print("No files found in the specified depth level")
        return

    for path, timestamp in modification_times.items():
        print(f"{timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')} : {path}")

if __name__ == "__main__":
    main()
