#include "utils.h"

#include <windows.h>

void CreateAndAttachConsole() {
  if (AttachConsole(ATTACH_PARENT_PROCESS)) {
    freopen("CONOUT$", "w", stdout);
    freopen("CONOUT$", "w", stderr);
  }
}
