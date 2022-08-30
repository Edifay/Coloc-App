enum Person { DARIUS, ARNAUD, EMPTY }

Person getPersonFromString(String person) {
  Person atReturn = Person.EMPTY;
  switch (person) {
    case "DARIUS":
      atReturn = Person.DARIUS;
      break;
    case "ARNAUD":
      atReturn = Person.ARNAUD;
      break;
    case "EMPTY":
      atReturn = Person.EMPTY;
  }
  return atReturn;
}

String getStringFromPerson(Person person){
  return person.toString().split(".")[1];
}
