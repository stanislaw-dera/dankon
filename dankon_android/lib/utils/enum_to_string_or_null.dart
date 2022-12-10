String? enumToStringOrNull(Enum? e, {onlyName = true}) {
  return onlyName ? e?.name.toString() : e?.toString();
}
