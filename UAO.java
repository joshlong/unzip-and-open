
// java --enable-preview --source 21  ~/josh-env/bin/UAO.java $HOME/Downloads/demo.zip

import java.io.*; 
import java.util.function.*;
import java.util.* ; 

void main(String[] args) throws Exception {
    // java --enable-preview --source 21  ~/josh-env/bin/UAO.java $HOME/Downloads/demo.zip
    var zipFile = new File(args[0]);
    var zipFileAbsolutePath = zipFile.getAbsolutePath();
    var folder = new File(zipFileAbsolutePath.substring(0, zipFileAbsolutePath.lastIndexOf(".")));
    new ProcessBuilder().command("unzip", "-a", zipFileAbsolutePath).inheritIO().start().waitFor();
    for (var k : Set.of("build.gradle", "build.gradle.kts", "pom.xml")) {
        var buildFile = new File(folder, k);
        if (buildFile.exists()) {
            new ProcessBuilder().command("idea", buildFile.getAbsolutePath()).inheritIO().start().waitFor();
        }
    }
}
