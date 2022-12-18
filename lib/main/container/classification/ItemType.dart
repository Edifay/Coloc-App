enum ItemType {
  ALIMENTAIRE,
  MENAGE,
  AUTRES,
}

String getStringFromItemType(ItemType type) {
  switch (type) {
    case ItemType.ALIMENTAIRE:
      return "ALIMENTAIRE";
    case ItemType.MENAGE:
      return "MENAGE";
    case ItemType.AUTRES:
      return "AUTRES";
  }
}

ItemType getItemTypeFromString(String? type) {
  if (type == getStringFromItemType(ItemType.ALIMENTAIRE)) {
    return ItemType.ALIMENTAIRE;
  } else if (type == getStringFromItemType(ItemType.MENAGE)) {
    return ItemType.MENAGE;
  }
  return ItemType.AUTRES;
}
