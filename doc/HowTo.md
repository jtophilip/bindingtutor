# How To

This chapter explains how to use some of the advanced features of BindingTutor.

## Editing and Saving Graphs

### Saving Graphs

To save a graph generated by BindingTutor for later use or editing click on the save graph button. You can save your figure in the following formats:

-   MATLAB figure (.fig)
-   Adobe Illustrator file (.ai)
-   EPS file (.eps)
-   JPEG image (.jpg)
-   Portable Document Format (.pdf)
-   Portable Network Graphics file (.png)
-   TIFF image (.tif)
-   Excel spreadsheet (.xls)
-   Comma separated value table (.csv)

If you wish to embed your figure in a PowerPoint presentation or a Word document, the best choice is probably a JPEG image. If you wish to include your figure in a LaTeX document, you should probably save it either as a PDF file or as an EPS file. Finally, if you wish to edit the graph, changing text or other graph properties, it is recommended to save the graph either in Adobe Illustrator format (if you have access to Illustrator), or in PNG format (for editing in any image editing software, including Photoshop).

If you'd like to save the curves as x and y values in a spreadsheet, see "Saving a Graph as a Spreadsheet" below.

### Editing Graphs

The graphs generated by BindingTutor can be edited in several ways. From inside the program, you can change the location of the legend box by clicking and dragging. You also can edit the legend text by double-clicking on it.

If you would like to see a particular part of the graph blown up, you can use the zoom in and out tools on the graph window, and then the hand tool to drag the graph to the desired region.

To edit the graph more extensively, two options are available. If you have MATLAB, you can save the graph as a MATLAB Figure (.FIG) file, and edit it as you would any other MATLAB graph. Otherwise, it is recommended to save as an Adobe Illustrator (.AI) file, and edit in Adobe Illustrator. You may also be able to edit an Illustrator file in the open-source [Inkscape](http://www.inkscape.org/) image editor.

## Saving a Graph as a Spreadsheet

To save the curves from a graph as x and y values in a spreadsheet, click on the save graph button in BindingTutor. Saving as an Excel file (.xls) will generate an Excel file containing the x and y values for all curves on the graph. Saving as a comma separated value file (.csv) will create a CSV table with the x and y values for all curves on the graph.

If you are running BindingTutor in Mac OS X or Linux, you cannot save your files as .xls. You can save them as .csv files and then open them in Excel. Please see [Troubleshooting](${DOCS}:Troubleshooting) for more information.

## Comparing Two Curves

To compare two curves in BindingTutor, first select "compare two curves" from the plotting mode box.

![image](${IMAGES}/howto-selectcomp){width=1.44in align=center}

This will cause a second model selection drop down box and set of model parameter input boxes to appear.

Enter the parameters for the curves you wish to compare in the two columns. The curves are independent of each other. An example of two curves to be compared is below.

![image](${IMAGES}/howto-enter2){width=5.127in align=center}

When you click the graph button, the curves will be plotted on the active graph or a new graph.

![image](${IMAGES}/howto-2curves){width=4.047in align=center}

If the X-axis is plotting total [L] or total [P], or in competition mode he program also will calculate the difference between the two curves and display the result.

![image](${IMAGES}/howto-result){width=2.013in align=center}

These values are calculated by computing the absolute and percentage difference between the curves at each point, and both the average and largest difference are reported for each. This feature is designed to help researchers determine whether the predicted differences between two curves are detectable given their expected experimental error.

This comparison is only done for curves plotted with the X-axis as [L] total or [P] total because the x-values for both curves are the same in that case, so the comparison calculations are unambiguous. When the X-axis is [L] free or [P] free the x-values for the curves will be different and the calculation of a comparison between the curves requires making assumptions about the binding behavior.
