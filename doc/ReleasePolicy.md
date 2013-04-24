A few things need to be checked before we release a new version of MTBindingSim.

## Freeze the Code Release

  1. Look at the issues list and make sure that all issues for this milestone have been resolved. If not, bump their milestones.
  2. Change the copyright dates on all source files if the year's changed.
     *  Split the `ChangeLog`, update the `ChangeLog` creation setup in `Makefile.am`.
     *  Add the old `ChangeLog` file to `src/Makefile.am` (in `DMG_DOCUMENTATION_FILES`) and to the NSIS install script in `build/MTBindingSim.nsi.in`.
  3. Bump the version number in `configure.ac`.
  4. Update the NEWS file with current user-visible changes.  Duplicate the same thing in the `ChangeLog.rst` file in the documentation.
  5. Double-check THANKS and AUTHORS to make sure they reflect reality.
  6. Make sure that all new features have been documented in the documentation.
  7. Once the code is frozen, update the changelog (`make changes`).
  8. Create a tag if this is a minor release, and a tag (for the new version) and a branch (for the old version) if this is a major release.

## Make and Upload Packages

  1. Produce updated source-code package (including `make distcheck`) and upload.
  2. Produce updated binaries and upload.  This includes `make dmg` on Mac, and creation of the two NSIS installers on Windows.
  3. Upload an updated documentation PDF.
  4. Switch over links on the download widget.
  5. Edit front page.
  6. Send a message to the -announce mailing list:
     
         Subject: MTBindingSim X.Y released
         
         ---------------------------
         - MTBindingSim X.Y RELEASED
         
         (DATE).
         
         The MTBindingSim development team is pleased to announce the 
         release of MTBindingSim version X.Y.  In addition to small bug 
         fixes, this new release introduces the following notable changes:
         
         * (CHANGES)
         * (CHANGES)
         
         To download this release, please visit our website at:
         
          <http://mtbindingsim.googlecode.com>
         
         New downloads are immediately available for Windows and Mac 
         systems, as well as source code and documentation.
         
         -- The MTBindingSim Developers
