
String statusToString(String statusOrder) {
  switch (statusOrder) {
    case "1":
      return "COMPLETADO";
    case "2":
      return "RECHAZADO";
    case "3":
      return "PROCESANDO";
    case "4":
      return "TRASNPORTACION";
    case "5":
      return "CANCELADO POR USUARIO";
    default:
      return "PENDIENTE";
  }
}