coffee -wc -o javascripts src/coffee & \
./node_modules/stylus/bin/stylus -w src/stylus -o stylesheets/ --use ./node_modules/nib/lib/nib & \
./node_modules/livereload/bin/livereload & \
serve
