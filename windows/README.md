README
======

### uni2sql.ps1

Converts unicode characters to some useful SQL.
    
    // Run with PowerShell_ISE.exe for unicode support.
    uni2sql.ps1
    Type range: 0x3041 0x3096     // Space separated range or single value.
    Done! Check and edit: out.tmp // Remove chars you don't need.

    // Run second pass
    uni2sql.ps1 - // Note the hyphen!
    ふ : fu bu pu // Type space separated additional values for char.
                  // Or simply ENTER to skip character.
                  // Ctrl+C to abort process half-way down.
    SQL script is ready: out.sql
