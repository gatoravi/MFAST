/* 

Copyright (c) 2009 Thomas Junier and Evgeny Zdobnov, University of Geneva
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
* Neither the name of the University of Geneva nor the names of its
    contributors may be used to endorse or promote products derived from this
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

struct canvas {
	int width;
	int height;
	char **lines;
	};

/* Creates a canvas of w chars by h lines. Positions on the canvas start at 0
 * (i.e., C-style).  Returns NULL iff canvas can't be allocated. */

struct canvas *create_canvas(int w, int l);

/* Prints the canvas lines */

void print(struct canvas*);

/* Draws a horizontal line on the canvas, on line 'line', from column 'start'
 * to column 'end'. The line is made of '-', except if there already is a '|',
 * in which case a '+' is written. */

void canvas_draw_hline(struct canvas*, int line, int start, int end);

/* Draws a vertical line on the canvas, on column 'col', form line 'start' to
 * line 'end'. The line is made of '|', except if there already is a '-',
 * in which case a '+' is written.  */

void canvas_draw_vline(struct canvas*, int col, int start, int end);

/* Writes the string, starting at (col, line) */

void canvas_write(struct canvas*, int col, int line, char *text);

/* Dumps the canvas onto stdout */

void canvas_dump(struct canvas*);

/* (Debugging) like canvas_dump(), but more info */

void canvas_inspect(struct canvas* canvasp);

/* Releases all memory used by the canvas. Don't use it after this! */

void destroy_canvas(struct canvas*);
