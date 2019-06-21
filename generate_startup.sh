#! /bin/bash
echo '#!/bin/bash' > startup.sh
echo '#installing ruby' >> startup.sh
tail -n$((`cat ./install_ruby.sh | wc -l` - 1)) ./install_ruby.sh >> startup.sh
echo '#installing mongo' >> startup.sh
tail -n$((`cat ./install_mongodb.sh | wc -l` - 1)) ./install_mongodb.sh >> startup.sh
echo '#deploying' >> startup.sh
tail -n$((`cat ./deploy.sh | wc -l` - 1)) ./deploy.sh >> startup.sh

