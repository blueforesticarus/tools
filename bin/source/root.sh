root () {
    #!/bin/bash
    cd "`hg root`" || cd "`git root`"
}
