params ["_group"];

/**
When LAMBS functions are applied, LAMBS may change original groups.
With that, the ref to the original group becomes null.
Persistent group ID is a way to mitigate that and have kind of a unique ID for the group that can be always requested.
 */

createHashMapFromArray [
	["original_units", units _group]
];
