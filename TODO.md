- OBJETIVO-OW-eCare.1.csv:"ID_Client(prop39)"

JOIN () -> DataExtract_Nov.csv:"user id (ow) (evar39)"
  - 41. "purchased packages (prop57)"
  - 42. "login profile (prop58)" perfil
  - 24. "client debt (prop18)" (*) deuda
  - 25. "new/repeat (prop21)" primera vez que ingresa

  - 31. "more megas (prop31)" (*)

  - 22. "client status (prop15)" cuenta: activo/inactivo
  - 29. "error cause (prop30)"
  - 30. "error code (prop35)"

  - 11. "Pages" (!)
  - 43. "link type (prop59)"

  - 1. "﻿"Date""
  - 39. "hh:mm (prop54)"

ID_Client(prop39):105512209

csvjoin -c "ID_Client(prop39)" "user id (ow) (evar39)" OBJETIVO-OW-eCare.1.csv DataExtract_Nov.csv



- OBJETIVO-OW-eCare.1.csv
  - 1. "Creation Date" (momento que salta la encuesta)
  -



  TensorBoard