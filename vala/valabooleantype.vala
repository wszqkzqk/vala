/* valabooleantype.vala
 *
 * Copyright (C) 2009  Jürg Billeter
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
 * A boolean type.
 */
public class Vala.BooleanType : ValueType {
	public BooleanType (Struct type_symbol, SourceReference? source_reference = null) {
		base (type_symbol, source_reference);
	}

	public override DataType copy () {
		var result = new BooleanType ((Struct) type_symbol, source_reference);
		result.value_owned = value_owned;
		result.nullable = nullable;
		return result;
	}
}
