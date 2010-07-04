============
Installation
============

MTBindingSim can be run in two ways. If you have MATLAB installed on your 
computer, you can download the MATLAB .m files and run MTBindingSim in MATLAB.
If you do not have MATLAB, you can download precompiled binaries and the
MATLAB Compiler Runtime, and run MTBindingSim as an independent program.
The instructions below will tell you how to download and run MTBindingSim
in both ways.

MTBindingSim Binaries
=====================

Before you begin, you need to know which operating system (Mac OS X or Windows)
you would like to run MTBindingSim in, and whether you have a 32 or 64 bit
operating system.  If you are not sure whether you have a 32 or 64 bit operating
system, go to `the appropriate section of the documentation <$(DOCS):OperatingSystem>`_ 
and follow the directions to determine which version you have.

Downloads
---------

You will need to download both the MATLAB Compiler Runtime and the MTBindingSim
binaries for your operating system from the `MTBindingSim download page`_.

Installation
------------

First, you need to install the MATLAB Compiler Runtime. On Windows, double
click the MCRinstaller.exe file to run the intsaller. On Mac, open the
.dmg bundle and then open the installer package.

Next, install MTBindingSim. First double click the .zip file to extract it
(automatic on Mac, requires a few clicks on Windows).  The instructions now
vary based upon which version of MTBindingSim you're running.

**Windows**: All Windows binaries are a single executable file.  Simply
double-click "MTBindingSim" or "MTBindingSim.exe".

**64-bit Mac**: 64-bit Mac OS X users are provided with a traditional OS X
application bundle.  Drag "MTBindingSim" to your Applications folder and
double-click it to start.

**32-bit Mac**: 32-bit Mac OS X users will need to start the MTBindingSim
binary from the terminal.  When you extracted the MTBindingSim binary .ZIP
file, it will have created a folder, ``mtbindingsim-X.Y-mac-bin``.  Open the
Terminal application (Applications, Utilities).  Type ``cd `` (that's ``cd`` and
then a space), and then drag and drop this folder into the Terminal window,
which will fill in the path to the folder.  Press enter.  Then type::

  ./run_MTBindingSim.sh

and MTBindingSim will be executed.  Occasionally, you will have to provide
the path to your MATLAB Compiler Runtime, which is often::

  ./run_MTBindingSim.sh /Applications/MATLAB/MATLAB_Compiler_Runtime/v713/

if you have installed the version of the MCR which we offer for download.
You are encouraged, if able, to use the 64-bit binary.


MTBindingSim in MATLAB
======================

Running MTBindingSim in MATLAB is the same for all platforms.

Downloads
---------

Download the MTBindingSim source code from the `MTBindingSim download page`_.

**NOTE:** If you are using Windows' built-in ZIP extraction tool, you may
run into problems extracting ZIP-format source bundles.  Our recommendation
is to download the free and open-source `7-Zip <http://www.7-zip.org/>`_.

Installation
------------

Unzip the source code file, which will create a folder ``mtbindingsim-X.Y``.
Open MATLAB, and open the ``mtbindingsim-X.Y/src/MTBindingSim.m`` file.  Run
MTBindingSim by clicking the green play button on the toolbar.


.. _MTBindingSim download page: http://code.google.com/p/mtbindingsim/downloads/list
