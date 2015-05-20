NODE_GYP=node node_modules/node-gyp/bin/node-gyp

all: node iojs

node: node_v1 node_v11 node_v14

iojs: iojs_v42 iojs_v43 iojs_v44

build = stat node_modules/node-gyp > /dev/null 2>&1 || npm install; \
        $(NODE_GYP) clean; \
        echo "Building $(4) for $(1) v$(3)"; \
        stat ~/.node-gyp/$(3) || ( \
            rm -f /tmp/$(1)-v$(3).tar.gz && \
            curl -o /tmp/$(1)-v$(3).tar.gz https://$(2)/dist/v$(3)/$(1)-v$(3).tar.gz && \
            $(NODE_GYP) install --target=$(3) --tarball=/tmp/$(1)-v$(3).tar.gz --dist-url=http://$(2)/dist && \
            rm -f /tmp/$(1)-v$(3).tar.gz \
        ); \
        $(NODE_GYP) configure --target=$(3) && \
            $(NODE_GYP) build node_ios_device && \
            mkdir -p out && \
            cp build/Release/node_ios_device.node out/$(4);

# Node.js 0.8.x
node_v1:
	$(call build,node,nodejs.org,0.8.28,node_ios_device_v1.node)

# Node.js 0.10.x
node_v11:
	$(call build,node,nodejs.org,0.10.38,node_ios_device_v11.node)

# Node.js 0.12.x
node_v14:
	$(call build,node,nodejs.org,0.12.3,node_ios_device_v14.node)

# io.js 1.0.x
iojs_v42:
	$(call build,iojs,iojs.org,1.0.4,iojs_ios_device_v42.node)

# io.js ^1.1.0
iojs_v43:
	$(call build,iojs,iojs.org,1.8.2,iojs_ios_device_v43.node)

# io.js 2.x
iojs_v44:
	$(call build,iojs,iojs.org,2.0.2,iojs_ios_device_v44.node)

clean:
	$(NODE_GYP) clean
	rm -rf out

.PHONY: clean node_v1 node_v11 node_v14 iojs_v42 iojs_v43 iojs_v44