#include <stddef.h>	// size_t
#include <stdio.h>	// fopen()
#include <string.h>	// strlen()
#include <getopt.h>
#include "../include/libbase64.h"

#define BUFSIZE 1024 * 1024

static char buf[BUFSIZE];
static char out[(BUFSIZE * 5) / 3];	// Technically 4/3 of input, but take some margin
size_t nread;
size_t nout;

static int
enc (FILE *fp)
{
	int ret = 1;
	struct base64_state state;

	base64_stream_encode_init(&state, 0);

	while ((nread = fread(buf, 1, BUFSIZE, fp)) > 0) {
		base64_stream_encode(&state, buf, nread, out, &nout);
		if (nout) {
			fwrite(out, nout, 1, stdout);
		}
		if (feof(fp)) {
			break;
		}
	}
	if (ferror(fp)) {
		fprintf(stderr, "read error\n");
		ret = 0;
		goto out;
	}
	base64_stream_encode_final(&state, out, &nout);

	if (nout) {
		fwrite(out, nout, 1, stdout);
	}
out:	fclose(fp);
	fclose(stdout);
	return ret;
}

static int
dec (FILE *fp)
{
	int ret = 1;
	struct base64_state state;

	base64_stream_decode_init(&state, 0);

	while ((nread = fread(buf, 1, BUFSIZE, fp)) > 0) {
		if (!base64_stream_decode(&state, buf, nread, out, &nout)) {
			fprintf(stderr, "decoding error\n");
			ret = 0;
			goto out;
		}
		if (nout) {
			fwrite(out, nout, 1, stdout);
		}
		if (feof(fp)) {
			break;
		}
	}
	if (ferror(fp)) {
		fprintf(stderr, "read error\n");
		ret = 0;
	}
out:	fclose(fp);
	fclose(stdout);
	return ret;
}

int
main (int argc, char **argv)
{
	char src[] = "foobarfoobarfoobarfoobarfoobarfoobarfoobarfoobar";
	int l = strlen(src);
	char out[100];
	char *out2 = malloc(l * 2);
	size_t srclen = sizeof(src) - 1;
	size_t outlen;

	base64_encode(src, srclen, out2, &outlen, 0);

	fwrite(out2, outlen, 1, stdout);
	puts("");
}
