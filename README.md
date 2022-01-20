## Purpose
A minimized surface for issues that just deals with `packed_tex` files as suggested here: https://github.com/Zylann/godot_heightmap_plugin/issues/298#issuecomment-1016754919

[Non-Server Run](packed_tex_test_2022-01-19_21-24-29.png)

## Problem
When running the server build of godot and the `packed_tex` custom resource it fails indicating it can't find the `packed_tex`.

```
./Godot_v3.4.2-stable_linux_server.64 --main-pack packed_tex_test.pck 
Godot Engine v3.4.2.stable.official.45eaa2daf - https://godotengine.org
 
ERROR: Failed loading resource: res://texture_data/HterrainServer_slot0_albedo_bump.packed_tex. Make sure resources have been imported by opening the project in the editor at least once.
   at: _load (core/io/resource_loader.cpp:270)
ERROR: res://PackedTexTest.tscn:3 - Parse Error: [ext_resource] referenced nonexistent resource at: res://texture_data/HterrainServer_slot0_albedo_bump.packed_tex
   at: poll (scene/resources/resource_format_text.cpp:412)
ERROR: Failed to load resource 'res://PackedTexTest.tscn'.
   at: load (core/io/resource_loader.cpp:206)
ERROR: Failed loading resource: res://PackedTexTest.tscn. Make sure resources have been imported by opening the project in the editor at least once.
   at: _load (core/io/resource_loader.cpp:270)
ERROR: Failed loading scene: res://PackedTexTest.tscn
   at: start (main/main.cpp:2011)
WARNING: ObjectDB instances leaked at exit (run with --verbose for details).
     at: cleanup (core/object.cpp:2064)
ERROR: Resources still in use at exit (run with --verbose for details).
   at: clear (core/resource.cpp:417)
ERROR: There are still MemoryPool allocs in use at exit!
   at: cleanup (core/pool_vector.cpp:63)

```

## Server Binary
The Godot server binary in use is: https://downloads.tuxfamily.org/godotengine/3.4.2/Godot_v3.4.2-stable_linux_server.64.zip
