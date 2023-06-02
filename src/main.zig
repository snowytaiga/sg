const std = @import("std");

var gpa_inst = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_inst.allocator();

const Token = enum {
	comma,
	dash,
	greater_than,
	illegal
};

const lexer = struct {
	var line: []const u8 = undefined;
	var tokens: []Token = undefined;
	
	pub fn lex_symbol(c: u8) Token {
		return switch (c) {
			',' => .comma,
			'-' => .dash,
			'>' => .greater_than,
			else => .illegal
		};
	}

	pub fn lex_keyword(kw: []const u8) Token {
					
	}

	pub fn lex() !void {
		var i: usize = 0;
		while (i < line.len - 1) : (i += 1) {
			if (isAlphanumeric(line[i])) {
				var buf = std.ArrayList(u8).init(gpa);	
				defer buf.deinit();
				while (i < line.len and isAlphanumeric(line[i])) {
					try buf.append(line[i]);
					i += 1;	
				}

				std.debug.print("{s}\n", .{buf.items}); 
			} else {
				std.debug.print("{}\n", .{lex_symbol(line[i])});
			}
		}
	}

	pub fn isAlphanumeric(c: u8) bool{
		return (std.ascii.isAlphanumeric(c) or c == '_' or c != ' ');
	}

};


// Fix this mess soon
pub fn main() !u8 {
	const args = try std.process.argsAlloc(gpa);
	defer std.process.argsFree(gpa, args);

	if (args.len != 2) {
		std.debug.print("usage : tsl <file>\n", .{});
		return 1;
	}

	var file = try std.fs.cwd().openFile(args[1], .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	const reader = buf_reader.reader();

	var buf: [1024]u8 = undefined;
	while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		lexer.line = line;
		try lexer.lex();
	}

	return 0;
}
