##
## bzip2
##

$(eval $(call rules-source,bzip2,$(SRCDIR)/steamrtdeps/bzip2))
$(eval $(call create-rules-common,bzip2,BZIP2,i386,unix))
$(eval $(call create-rules-common,bzip2,BZIP2,x86_64,unix))
$(eval $(call create-rules-common,bzip2,BZIP2,aarch64,unix))

$(OBJ)/.bzip2-%-configure:
	@echo ":: configuring bzip2-$*..." >&2
	touch $@

$(OBJ)/.bzip2-%-build:
	@echo ":: building bzip2-$*..." >&2
	rsync --filter=:C --exclude '*~' --exclude .git --exclude compile_commands.json --info=name -Oarx --delete "$(BZIP2_SRC)/" "$(BZIP2_$*_OBJ)/" $(--quiet?)
	+$(MAKE) -C "$(BZIP2_$*_OBJ)" -f Makefile-libbz2_so clean
	+$(MAKE) -C "$(BZIP2_$*_OBJ)" -f Makefile-libbz2_so \
	    CC="$($*-unix_TARGET)-gcc" \
	    CFLAGS="-fpic -fPIC -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64 $($*_CFLAGS) $(CFLAGS)" \
	    LDFLAGS="$($*_LDFLAGS) $(LDFLAGS)"
	mkdir -p "$(BZIP2_$*_LIBDIR)/$($*-unix_LIBDIR)" "$(BZIP2_$*_INCDIR)"
	cp -a "$(BZIP2_$*_OBJ)/libbz2.so.1.0.8" "$(BZIP2_$*_LIBDIR)/$($*-unix_LIBDIR)/"
	ln -sfn libbz2.so.1.0.8 "$(BZIP2_$*_LIBDIR)/$($*-unix_LIBDIR)/libbz2.so.1.0"
	ln -sfn libbz2.so.1.0.8 "$(BZIP2_$*_LIBDIR)/$($*-unix_LIBDIR)/libbz2.so"
	cp -a "$(BZIP2_$*_OBJ)/bzlib.h" "$(BZIP2_$*_INCDIR)/"
	touch $@

BZIP2_DEPENDENCY := bzip2
