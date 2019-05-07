# Hooker
## Consignes pour exécuter le Hooker.

Requirements :
- Linux version 5.0 
- Clang version >= 6.0       
      wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
      sudo apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main"
      sudo apt-get update
      sudo apt-get install -y clang-6.0
      sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 100 
      sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 100 
      sudo update-alternatives --install /usr/bin/llc llc /usr/bin/llc-6.0 100 

Execution :
- git clone
- cd Hooker/
- sudo make
- par la suite tu exécutes (tu verras dans le makefile les cibles sous le nom de TARGET, que tu pourrais exécuter)
