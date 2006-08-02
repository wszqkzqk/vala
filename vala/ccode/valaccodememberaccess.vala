/* valaccodememberaccess.vala
 *
 * Copyright (C) 2006  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.

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
 * Represents an access to a struct member in the C code.
 */
public class Vala.CCodeMemberAccess : CCodeExpression {
	/**
	 * The parent of the member.
	 */
	public CCodeExpression! inner { get; set construct; }
	
	/**
	 * The name of the member.
	 */
	public string! member_name { get; set construct; }
	
	/**
	 * Specifies whether the member access happens by pointer dereferencing.
	 */
	public bool is_pointer { get; set; }
	
	public override void write (CCodeWriter! writer) {
		inner.write (writer);
		if (is_pointer) {
			writer.write_string ("->");
		} else {
			writer.write_string (".");
		}
		writer.write_string (member_name);
	}
}
