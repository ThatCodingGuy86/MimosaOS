
echo "This will likely take a while, (~1.5hrs) so sit back and relax"


echo "Installing GCC dependencies..."

sudo apt install bison
sudo apt install flex
sudo apt install libgmp3-dev
sudo apt install libmpc-dev
sudo apt install libmpfr-dev
sudo apt install texinfo


echo "Downloading Binutils source..."

mkdir binutils-src

wget -P ./binutils-src/ "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.gz"


echo "Downloading GCC source..."

mkdir gcc-src

wget -P ./gcc-src/ "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.gz"


echo "Extracting the Binutils source..."

cd binutils-src

tar -xzf binutils-2.38.tar.gz

cd ../


echo "Extracting the GCC source..."

cd gcc-src

tar -xzf gcc-12.1.0.tar.gz

cd ../


echo "Building the GCC cross-compiler..."

echo "Setting up flags..."
export PREFIX="$HOME/opt/cross"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

echo "Building binutils..."
cd binutils-src

mkdir build-binutils
cd build-binutils
../binutils-2.38/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ../../

echo "Building the GCC cross-compiler..."

cd gcc-src
 
which -- $TARGET-as || echo $TARGET-as is not in the PATH
 
mkdir build-gcc
cd build-gcc
../gcc-12.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

cd ../../

echo "Finished kernel toolchain, installing Clang for UEFI bootloader"

sudo apt install clang

echo "Cleaning up..."

rm -r -f gcc-src
rm -r -f binutils-src

echo "If there were any errors, please open an issue on the Github page with the error message and a description of what enviorment you're running in."
