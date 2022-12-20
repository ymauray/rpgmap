#! /bin/env bash
set -x

for shader in assets/shaders/*.frag.glsl
do
    glslc --target-env=opengl -fshader-stage=fragment -o "${shader%.glsl}".spv "${shader}"
done
