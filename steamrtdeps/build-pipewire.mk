##
## PipeWire ALSA PCM plugin
##

$(eval $(call rules-source,pipewire-alsa,$(SRCDIR)/steamrtdeps/pipewire/pipewire-alsa/alsa-plugins))
$(eval $(call create-rules-common,pipewire-alsa,PIPEWIRE_ALSA,x86_64,unix))
$(eval $(call create-rules-common,pipewire-alsa,PIPEWIRE_ALSA,aarch64,unix))

$(OBJ)/.pipewire-alsa-post-source:
	patch -d "$(PIPEWIRE_ALSA_SRC)" -Np1 -i "$(realpath $(SRCDIR)/patches/pipewire/0001-alsa-pcm-support-aux-channel-map.patch)"
	touch $@

$(OBJ)/.pipewire-alsa-x86_64-configure:
	@echo ":: configuring pipewire-alsa-x86_64..." >&2
	touch $@

$(OBJ)/.pipewire-alsa-aarch64-configure:
	@echo ":: configuring pipewire-alsa-aarch64..." >&2
	touch $@

$(OBJ)/.pipewire-alsa-x86_64-build:
	@echo ":: building pipewire-alsa-x86_64..." >&2
	mkdir -p "$(PIPEWIRE_ALSA_x86_64_LIBDIR)/$(x86_64-unix_LIBDIR)/alsa-lib"
	env $(PIPEWIRE_ALSA_x86_64_ENV) \
	    "$(x86_64-unix_TARGET)-gcc" -shared -fPIC -DPIC \
	    $$("$(x86_64-unix_TARGET)-pkg-config" --cflags alsa libpipewire-0.3 libspa-0.2) \
	    $(x86_64_CFLAGS) $(CFLAGS) \
	    -Wl,-soname,libasound_module_pcm_pipewire.so \
	    -o "$(PIPEWIRE_ALSA_x86_64_LIBDIR)/$(x86_64-unix_LIBDIR)/alsa-lib/libasound_module_pcm_pipewire.so" \
	    "$(PIPEWIRE_ALSA_SRC)/pcm_pipewire.c" \
	    $$("$(x86_64-unix_TARGET)-pkg-config" --libs alsa libpipewire-0.3 libspa-0.2) \
	    $(x86_64_LDFLAGS) $(LDFLAGS)
	touch $@

$(OBJ)/.pipewire-alsa-aarch64-build:
	@echo ":: building pipewire-alsa-aarch64..." >&2
	mkdir -p "$(PIPEWIRE_ALSA_aarch64_LIBDIR)/$(aarch64-unix_LIBDIR)/alsa-lib"
	env $(PIPEWIRE_ALSA_aarch64_ENV) \
	    "$(aarch64-unix_TARGET)-gcc" -shared -fPIC -DPIC \
	    $$("$(aarch64-unix_TARGET)-pkg-config" --cflags alsa libpipewire-0.3 libspa-0.2) \
	    $(aarch64_CFLAGS) $(CFLAGS) \
	    -Wl,-soname,libasound_module_pcm_pipewire.so \
	    -o "$(PIPEWIRE_ALSA_aarch64_LIBDIR)/$(aarch64-unix_LIBDIR)/alsa-lib/libasound_module_pcm_pipewire.so" \
	    "$(PIPEWIRE_ALSA_SRC)/pcm_pipewire.c" \
	    $$("$(aarch64-unix_TARGET)-pkg-config" --libs alsa libpipewire-0.3 libspa-0.2) \
	    $(aarch64_LDFLAGS) $(LDFLAGS)
	touch $@

PIPEWIRE_ALSA_DEPENDENCY := pipewire-alsa
