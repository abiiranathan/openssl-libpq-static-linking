OPENSSL_INSTALLDIR=openssl_install
PGINSTALL_DIR=postgresql_install

all: openssl_test libpq_test

openssl_test:
	gcc -o openssl_test openssl_test.c -I"$(OPENSSL_INSTALLDIR)/include" \
    "$(OPENSSL_INSTALLDIR)/lib64/libssl.a" \
    "$(OPENSSL_INSTALLDIR)/lib64/libcrypto.a" \
    -ldl -lpthread -lm

libpq_test:
	gcc -o libpq_test libpq_test.c \
	-I"$(PGINSTALL_DIR)/include" \
	-I"$(OPENSSL_INSTALLDIR)/include" \
	"$(PGINSTALL_DIR)/lib/libpq.a" \
	"$(PGINSTALL_DIR)/lib/libpgcommon.a" \
	"$(PGINSTALL_DIR)/lib/libpgport.a" \
	"$(OPENSSL_INSTALLDIR)/lib64/libssl.a" \
	"$(OPENSSL_INSTALLDIR)/lib64/libcrypto.a" \
	-ldl -lpthread -lm
	
clean:
	rm -rf openssl_test libpq_test
	
.PHONY: openssl_test libpq_test clean