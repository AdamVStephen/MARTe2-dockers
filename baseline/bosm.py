#!/usr/bin/env python3

"""
bosm : bill of software materials.

scan specified scripts and assemble a report with respect to package managers.
"""

import re
#import regex
import pdb
import sys

class PackageManager:
    def __init__(self, name):
        self.name = name
        #self.install_pattern = re.compile('''^\s*%s\s+(\S+)\s+(\S+)''' % command)
        #self.install_match = regex.match('''^\s+%s\s+(\S+)\s+(\S+)
   
    def parse_install_command(self, command):
        """Parse an install command to extract package names."""
        command = command.strip()
        if self.name == "apt":
            command = command.replace("apt-get", "apt")
        if not command.startswith(self.name): return None
        command = command.replace(self.name, "")
        if "groups install" in command:
            command = command.replace("groups install", "")
        elif "install" in command:
            command = command.replace("install", "")
        else:
            return None
        command = command.replace("-y", "")
        command = command.replace("-y", "")
        packages = command.split()
        return packages 
        

def parse_script(script, managers=["apt", "yum"]):
    """Extract package manager commands from a script."""
    with open(script, 'r') as fh:
        lines = fh.readlines()
    search = {}
    for m in managers:
        search[m] = {}
        search[m]['PackageManager'] = PackageManager(m)
        search[m]['packages'] = set()
    for line in lines:
        for m in managers:
            packages = search[m]['PackageManager'].parse_install_command(line)
            if packages is not None:
                for package in packages:
                    search[m]['packages'].add(package)
    return search

def main(driver_scripts):
    for s in driver_scripts:
        search = parse_script(s)
        for m in search:
            print(m)
            packages = search[m]['packages']
            for p in sorted(packages):
                print("\t%s" % p)
    # TODO : expand more generically if we support more than apt/yum
    in_yum = search['yum']['packages']
    in_apt = search['apt']['packages']
    n_yum = len(in_yum)
    n_apt = len(in_apt)
    in_all = in_yum | in_apt
    n_all = len(in_all)
    in_common = in_yum & in_apt
    n_common = len(in_common)
    only_yum = in_yum - in_apt
    n_only_yum = len(only_yum)
    only_apt = in_apt - in_yum
    n_only_apt = len(only_apt)
    rep = []
    rep.append('%-45s: %d' % ('Yum packages : ', n_yum))
    rep.append('%-45s: %d' % ('Apt packages : ', n_apt))
    rep.append('%-45s: %d' % ('Total number of packages : ', n_all))
    rep.append('%-45s: %d' % ('In common : ', n_common))
    rep.append('%-45s: %d' % ('Yum only : ', n_only_yum))
    rep.append('%-45s: %d' % ('Apt only : ', n_only_apt))
    print('\n'.join(rep))    
    if n_only_yum > n_only_apt:
        only_apt_list = list(only_apt)
        only_apt_list.extend(['' for i in range(n_only_yum - n_only_apt)])
        only_yum_list = list(only_yum)
    elif n_only_apt > n_only_yum:
        only_apt_list = list(only_apt)
        only_yum_list = list(only_yum)
        only_yum_list.extend(['' for i in range(n_only_yum - n_only_apt)])
    else:
        only_yum_list = list(only_yum)
        only_apt_list = list(only_apt)
    only_yum_list.sort()
    only_apt_list.sort()
    for (y,a) in zip(only_yum_list, only_apt_list):
        print("%-60s : %-60s\n" % (y,a))

if __name__ == '__main__':
    driver_scripts = ['install-packages.sh']
    main(driver_scripts)
