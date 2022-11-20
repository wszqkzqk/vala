/* valaintegerliteral.vala
 *
 * Copyright (C) 2006-2010  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;

/**
 * Represents an integer literal in the source code.
 */
public class Vala.IntegerLiteral : Literal {
	/**
	 * The literal value.
	 */
	public string value { get; private set; }

	public string type_suffix { get; private set; }

	/**
	 * Creates a new integer literal.
	 *
	 * @param i      literal value
	 * @param source reference to source code
	 * @return       newly created integer literal
	 */
	public IntegerLiteral (string i, SourceReference? source = null) {
		value = i;
		source_reference = source;
	}

	public override void accept (CodeVisitor visitor) {
		visitor.visit_integer_literal (this);

		visitor.visit_expression (this);
	}

	public override string to_string () {
		return value;
	}

	public override bool is_pure () {
		return true;
	}

	public override bool check (CodeContext context) {
		if (checked) {
			return !error;
		}

		checked = true;

		// Support the underscore symbol separates digits in number values
		string[] components = value.split ("_");
		value = string.joinv("", components);

		int l = 0;
		while (value.has_suffix ("l") || value.has_suffix ("L")) {
			l++;
			value = value.substring (0, value.length - 1);
		}

		bool u = false;
		if (value.has_suffix ("u") || value.has_suffix ("U")) {
			u = true;
			value = value.substring (0, value.length - 1);
		}

		int64 n;
		if (value.has_prefix ("0b")) {
			uint64 m = 0;
			string v = value.substring (2, value.length);
			for (long i = v.length - 1; i > 0; i -= 1) {
				if (v[i] == '1') {
					if (v.length - 1 - i >= 64) {
						Report.warning (source_reference, "integer constant is too large");
						m = uint64.MAX;
						break;
					}
					m += (1 << (v.length - 1 - i));
				} else if (v[i] != '0') {
					Report.error (source_reference, "invalid digit '%c' in binary literal".printf (v[i]));
					error = true;
					break;
				}
			}
			value = m.to_string ();
			n = (int64) m;
		} else if (value.has_prefix ("0o")) {
			uint64 m = 0;
			string v = value.substring (2, value.length);
			for (long i = v.length - 1; i > 0; i -= 1) {
				if (v[i].isdigit () && v[i] != '8' && v[i] != '9') {
					int num = v[i].digit_value ();
					if ((num == 1 && ((v.length - 1 - i) * 3 >= 64))
					|| (1 < num < 4 && ((v.length - 1 - i) * 3 + 1 >= 64))
					|| (num >= 4 && ((v.length - 1 - i) * 3 + 2 >= 64))) {
						Report.warning (source_reference, "integer constant is too large");
						m = uint64.MAX;
						break;
					}
					m += (num << ((v.length - 1 - i) * 3));
				} else {
					Report.error (source_reference, "invalid digit '%c' in binary literal".printf (v[i]));
					error = true;
					break;
				}
			}
			value = m.to_string ();
			n = (int64) m;
		} else {
			n = int64.parse (value);
		}
		if (!u && (n > int.MAX || n < int.MIN)) {
			// value doesn't fit into signed 32-bit
			l = 2;
		} else if (u && n > uint.MAX) {
			// value doesn't fit into unsigned 32-bit
			l = 2;
		}

		string type_name;
		if (l == 0) {
			if (u) {
				type_suffix = "U";
				type_name = "uint";
			} else {
				type_suffix = "";
				type_name = "int";
			}
		} else if (l == 1) {
			if (u) {
				type_suffix = "UL";
				type_name = "ulong";
			} else {
				type_suffix = "L";
				type_name = "long";
			}
		} else {
			if (u) {
				type_suffix = "ULL";
				type_name = "uint64";
			} else {
				type_suffix = "LL";
				type_name = "int64";
			}
		}

		var st = (Struct) context.root.scope.lookup (type_name);
		// ensure attributes are already processed
		st.check (context);

		value_type = new IntegerType (st, value, type_name);

		return !error;
	}

	public override void emit (CodeGenerator codegen) {
		codegen.visit_integer_literal (this);

		codegen.visit_expression (this);
	}
}
