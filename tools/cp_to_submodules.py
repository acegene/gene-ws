#!/usr/bin/env python3

import argparse
import difflib
import filecmp
import inspect
import os
import shutil

from typing import Any, Type, Sequence, Union

from utils import path_utils

PATH_THIS = str(os.path.abspath(inspect.getsourcefile(lambda: 0)))
DIR_THIS = str(os.path.dirname(PATH_THIS))
BASE_THIS = str(os.path.basename(PATH_THIS))

# TODO: path clean fix


def raise_if_false(exception: Type[Exception], expression: bool, print_obj: Any = None) -> None:
    """Throw <exception> if <expression> == False"""
    if not expression:
        if print_obj != None:
            print(print_obj)
        raise exception


def parse_inputs() -> None:
    """Parse cmd line inputs; set, check, and fix script's default variables"""
    #### default args
    module_dir = os.path.dirname(DIR_THIS)
    submodules_dir = os.path.join(module_dir, "repos")
    submodules_dirs = [os.path.join(submodules_dir, sub) for sub in os.listdir(submodules_dir)]
    files = [os.path.join(module_dir, f) for f in [".gitattributes", ".gitignore", "pyproject.toml"]]
    #### cmd line args parser
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir-module", "--dm", default=module_dir, help="dir of module")
    parser.add_argument("--dirs-submodules", "--ds", nargs="+", default=submodules_dirs, help="dirs of submodules")
    parser.add_argument("--files", nargs="+", default=files, help="files to cp")
    parser.add_argument("--force", "-f", action="store_true", default=False, help="overwrite files if they exist")
    args = parser.parse_args()
    #### check inputs
    raise_if_false(ValueError, os.path.isdir(args.dir_module))
    raise_if_false(ValueError, all([os.path.isdir(arg) for arg in args.dirs_submodules]))
    raise_if_false(ValueError, all([os.path.isfile(arg) for arg in args.files]), [arg for arg in args.files])
    #### change file paths to relative # TODO: check files in module dir
    dir_module = path_utils.path_clean(args.dir_module)
    files_rel = [os.path.relpath(path_utils.path_clean(f), dir_module) for f in args.files]
    #### return args
    return dir_module, [path_utils.path_clean(d) for d in args.dirs_submodules], files_rel, args.force


if __name__ == "__main__":
    dir_module, dirs_submodules, files, force = parse_inputs()
    for dir_sub in dirs_submodules:
        for f in files:
            src = os.path.join(dir_module, f)
            dst = os.path.join(dir_sub, f)
            with open(src, "r", encoding="cp437") as src_file:
                if os.path.exists(dst):
                    if not filecmp.cmp(src, dst):
                        with open(dst, "r", encoding="cp437") as dst_file:
                            diff = difflib.unified_diff(
                                dst_file.readlines(),
                                src_file.readlines(),
                                fromfile="original",
                                tofile="edited",
                            )
                            print(f"Showing diff for '{src}' and '{dst}':")
                            for line in diff:
                                print(line)
                            if not force:
                                print(f"WARNING: {BASE_THIS}: '{src}' != '{dst}' but --force was not specified.")
                                continue
                    else:
                        continue
            print(f"cp '{src}' '{dst}'")
            shutil.copy2(src, dst)
