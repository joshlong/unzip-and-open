#!/usr/bin/env python3

import os
import subprocess
import sys

if __name__ == '__main__':

    def run(c):
        print('running: %s' % c)
        return subprocess.check_call(c, shell=True)

    assert len(sys.argv) > 1 and sys.argv[1].endswith('.zip'), 'you must specify a .zip file to open.'
    zip = os.path.abspath(sys.argv[1])
    assert os.path.exists(zip), 'zip file not found.'
    folder_name = zip.split('.')[0]
    try:
        run('unzip -a %s' % zip)
    except:
        print("non-zero exit code but we proceed anyway..")

    gradle_build_groovy = os.path.join(folder_name, 'build.gradle')
    gradle_build_kotlin = os.path.join (folder_name , 'build.gradle.kts')
    mvn_pom = os.path.join(folder_name, 'pom.xml')
    success = False 
    build_files = [ gradle_build_groovy , gradle_build_kotlin , mvn_pom]

    for fn in  build_files: 
        if os.path.exists (fn )  : 
            run ('idea %s' % fn )
            success = True 
    assert success , 'valid build file (one of: %s) not found'  %  ','.join(build_files)
