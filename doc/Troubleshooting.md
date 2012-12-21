# Troubleshooting

## Downloading and Installation

### There are password-protected files in your ZIP file

or

### I can't open your ZIP file

If you are running Windows, there is a bug in the built-in Windows ZIP file extractor that occasionally causes trouble with our releases. Try downloading and installing the free and open source [7-Zip ZIP extractor](http://www.7-zip.org), and extracting MTBindingSim using it instead. If you are not running Windows, or if you have trouble even when using 7-Zip, please file a support ticket (see our specific information about Filing a Support Ticket below).

### MTBindingSim doesn't run

On a Mac, make sure you have downloaded and installed the MATLAB Compiler Runtime (MCR), available at [the MTBindingSim home page.](http://bindingtutor.org/mtbindingsim/)

On Windows, the installer should download and install the MATLAB Compiler Runtime (MCR) if you don't already have it. If you get an error that the MCR cannot be found, you probably have an old version of the MCR, which prevents the installer from installing the new version. Uninstall the old version if you don't need it for any other programs and then manually download and install the updated version from [the MTBindingSim home page.](http://bindingtutor.org/mtbindingsim/)

If you have successfully installed all the prerequisites and still cannot get MTBindingSim to run, try Filing a Support Ticket below.

## Graphing

### My graph doesn't show up

If you graph multiple simulations on the same graph, the axes will be set to show the full range of all curves. If you have curves with very different values, you may not be able to see all of the curves on the same graph. Try closing the graph and making a new graph, paying attention to the range of the X- and Y-axis.

Also, if you graph two very nearly identical graphs at the same time, the line for the last one to be graphed may lie precisely on top of the line for the first to be graphed, making the first line invisible. Try graphing your curves one-at-a-time, and comparing the graphs.

### My graph looks wrong

Your graph looking wrong could have several causes. First, make sure that the x- and y-axis ranges are appropriate for your graph.

If you are confident that you are looking at the graph with appropriate axes and it still looks wrong or strange, it is possible that the program has calculated your graph incorrectly. While we have made every attempt to ensure that MTBindingSim will always calculate the correct graph, it is possible that we missed something. Please submit a bug report on our website and we will attempt to fix the problem. To help us diagnose the issue you are having, it would be very helpful if you can run the graph several times, tweaking the parameters, to determine what parameter or combination of parameters is causing the problem. Thank you
for helping us keep MTBindingSim working properly!

## Saving Your Results

### I can't save XLS files

MATLAB saves XLS-format spreadsheets by communicating with Microsoft Excel in a manner which only works on Windows. If you wish to save a spreadsheet on Mac OS X or Linux, you can save in CSV format instead. CSV files can be opened by any version of Microsoft Excel or your favorite spreadsheet program.

For more information about the limitations of MATLAB's communication with Microsoft Excel, see [MathWorks Solution 1-2SJUON](http://www.mathworks.com/support/solutions/en/data/1-2SJUON/index.html?solution=1-2SJUON).

## Other

### I need help, can I contact the developers?

or

### I think I've found a bug, how do I report it?

or

### I have an idea for a great new feature!

Head to the next section and learn about Filing a Support Ticket.

## Filing a Support Ticket

MTBindingSim is hosted on Google Code, and we use its "Issues" system for keeping track of support requests. For your best chance at support, please file a ticket there, rather than e-mailing one of the developers.

When should you file a support ticket? In general, if you have a question that you just can't get answered in the documentation, if you have a bug to report, or if you have an idea for a new feature, you should send us a message.

Rather than including it in the documentation, we keep up-to-date information about [how to file a support ticket](https://github.com/jtophilip/mtbindingsim/wiki/FilingATicket) on the MTBindingSim website. Please visit there for the latest information about how to get MTBindingSim support.
