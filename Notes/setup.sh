# VSCode
https://marketplace.visualstudio.com/items?itemName=Ikuyadeu.r

# spain_data.r
https://www.xquartz.org/

xcode-select --install


brew update && brew install llvm
touch ~/.R/Makevars

# if you downloaded llvm manually above, replace with your chosen NEW_PATH/clang
LLVM_LOC = /usr/local/opt/llvm
CC=$(LLVM_LOC)/bin/clang -fopenmp
CXX=$(LLVM_LOC)/bin/clang++ -fopenmp
# -O3 should be faster than -O2 (default) level optimisation ..
CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe
LDFLAGS=-L/usr/local/opt/gettext/lib -L$(LLVM_LOC)/lib -Wl,-rpath,$(LLVM_LOC)/lib
CPPFLAGS=-I/usr/local/opt/gettext/include -I$(LLVM_LOC)/include -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

R install.packages("data.table")

# world_data.r
R install.packages("devtools")
R install.packages("httr")
R install.packages("dplyr")

# ggplot
R install.packages("tidyverse")
R install.packages("gridExtra")