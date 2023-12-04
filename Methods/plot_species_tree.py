from matplotlib import pyplot as plt
from sys import argv as args


def main():
    fig = plt.figure(figsize=(10, 10))
    treeNewick(args[1], subp := plt.subplot())
    xmin, xmax = subp.get_xlim()
    subp.set_xlim([xmin, xmax * 1.5])
    plt.savefig("../Results/species_tree.png")


def treeNewick(newick: str, plot, root_loc="left", leafLabels=True, showScale=True):
    """
    Plots a dendogram from a newick-formatted tree.
    This method is currently developed for this script only and works well with it,
    but for general use, there is no check, if the newick string is correct, and no
    method to make it compatible.

    Works properly with the WPGMA-returned newick with following EBNF:
    tree => "(" (tree|label) ":" distance "," (tree|label) ":" distance ")" ";"
    label => str
    distance => float

    other possible strings aren't tested
    """

    def recursive(newick: str, plot, x=0., **kwargs) -> "tuple[float, float, float]":
        """
        Plots a dendogram recursively from a given newick string, root is left.
        This is done in 3 steps:
        1. reach child-level: There are being the child labels plotted and their horizontal branches drawn
        loop till end:
            2. connection: horizontal branches of the next level are drawn recursively, so here will they be connected by the returned y-positions of these branches
            3. root-drawing: if two branches were connected horizontally, there is the root branch following, fitting to the middle of the vertical connection branch

        x: the x-position where to plot the root
        kwargs: treeDepth=0, lowestLeaf=x, leafLabels=True, nodeLabels=True, treeColor="black"

        #Return:
        tuple of current tree depth, y-value of lowest leaf and self y-value
        """
        if newick[0] == "(" and newick[-1] == ")":
            newick = newick[1:-1]

        lowestLeaf = kwargs.get("lowestLeaf", 15)  # important to have the same distance between the children/leafs
        treeColor = kwargs.get("treeColor", "black")
        nodeLabels = kwargs.get("nodeLabels", True)  # not used for this script, but can be implemented
        leafLabels = kwargs.get("leafLabels", True)
        kwargs["treeDepth"] = kwargs.get("treeDepth", 0)
        myPosY = 0  # necessary to return it to center the previous root properly

        if newick[0] == "(":

            # detect end of the subtree by finding its closing bracket
            splitIndex, openBrackets = 1, 1  # splitIndex is one behind the character
            while openBrackets > 0:
                openBrackets += newick[splitIndex] == "("
                openBrackets -= newick[splitIndex] == ")"
                splitIndex += 1
            splitIndex += newick[splitIndex:].find(",")  # if there is a subtree following like in (subtree)A:1,(subtree)B:1 then the following comma is the end

            # splitIndex is now the index of the comma after the tree or (if no comma there) the last bracket's index

            if newick[splitIndex] == ")":  # if it's sth. like (subTree)C:1             -> root-drawing (horizontal)
                label, length = newick[splitIndex+1:].split(":")
                kwargs["treeDepth"], kwargs["lowestLeaf"], myPosY = recursive(newick[1: splitIndex], plot, x + float(length), **kwargs)
                # if nodeLabels:
                #    plot.text(x + float(length), myPosY, " " + label)
                draw([x, x + float(length)], [myPosY, myPosY], treeColor=treeColor)

            else:  # if it's sth. like (subTree)R:1,(subTree)Q:1                        -> connection (vertical)
                upper, lower = newick[:splitIndex], newick[splitIndex+1:]
                kwargs["treeDepth"], kwargs["lowestLeaf"], upperPos = recursive(upper, plot, x, **kwargs)
                kwargs["treeDepth"], kwargs["lowestLeaf"], lowerPos = recursive(lower, plot, x, **kwargs)
                draw([x, x], [upperPos, lowerPos], treeColor=treeColor)
                myPosY = (upperPos - lowerPos) / 2 + lowerPos  # centering for the previous root-line

        elif "," in newick:  # if it's sth. like A:1,(subtree)B:1                       -> connection (vertical)
            upper, lower = newick.split(",", 1)
            kwargs["treeDepth"], kwargs["lowestLeaf"], upperPos = recursive(upper, plot, x, **kwargs)
            kwargs["treeDepth"], kwargs["lowestLeaf"], lowerPos = recursive(lower, plot, x, **kwargs)
            draw([x, x], [upperPos, lowerPos], treeColor=treeColor)
            myPosY = (upperPos - lowerPos) / 2 + lowerPos

        elif newick:  # if it's sth. like A:1  # will only be reached if A:1 is a leaf  -> child-level (horizontal)
            label, length = newick.split(":")
            myPosY = lowestLeaf-1
            kwargs["treeDepth"] = max(kwargs.get("treeDepth", 0), x + float(length))
            draw(x + float(length), myPosY, label)  # plot label
            draw([x, x + float(length)], [myPosY, myPosY], treeColor=treeColor)
            kwargs["lowestLeaf"] = myPosY

        return kwargs["treeDepth"], kwargs["lowestLeaf"], myPosY

    def draw(x, y, label=None, treeColor="black"):
        """
        Simplifies plotting in right location and alignment
        """
        if label is None:  # -> draw a line
            if root_loc in ("left", "right"):
                plot.plot(x, y, color=treeColor)
            else:
                plot.plot(y, x, color=treeColor)

        else:  # -> write text into the plot (for children)
            label = " %s " % label
            alpha = float(leafLabels)  # labels are always plotted to return the order of children, alpha makes them invisible if wanted
            if root_loc == "left":
                plot.text(x, y, label, alpha=alpha, verticalalignment="center")
            elif root_loc == "right":
                plot.text(x, y, label, alpha=alpha, verticalalignment="center", horizontalalignment="right")
            elif root_loc == "bottom":
                plot.text(y, x, label, alpha=alpha, horizontalalignment="center", rotation=90)
            else:
                plot.text(y, x, label, alpha=alpha, verticalalignment="top", horizontalalignment="center", rotation=90)

    newick = newick.replace(" ", "")
    if newick[-1] != ";":
        raise ValueError("Newick string doesn't end with a semicolon")
    if newick[-2] != ")":
        if newick.rfind(":") < newick.rfind(")"):
            newick = "%s:0;" % newick[:-1]

    depth, _, _ = recursive(newick[:-1], plot, leafLabels=leafLabels)

    plot.spines['bottom'].set_visible(False)
    plot.spines['top'].set_visible(False)
    plot.spines['left'].set_visible(False)
    plot.spines['right'].set_visible(False)

    plot.set_xlim([0, depth])
    plot.set_xticks([0, round(depth/2, 2),  round(depth, 2)])

    plot.yaxis.set_visible(False)
    plot.xaxis.set_visible(False)

    if showScale:
        plot.xaxis.set_visible(True)
        plot.spines['bottom'].set_visible(True)

    allLabels = [text.get_text()[1:-1] for text in plot.texts]

    # the following mirrors the plot to locate the root correctly
    if root_loc == "right":
        plot.set_xticklabels([round(depth, 2),  round(depth/2, 2), 0])
        plot.invert_xaxis()

    elif root_loc != "left":
        allLabels = allLabels[::-1]
        if showScale:
            plot.spines["left"].set_visible(True)
            plot.spines["bottom"].set_visible(False)
            plot.yaxis.set_visible(True)
            plot.xaxis.set_visible(False)
        plot.autoscale("x")
        plot.set_ylim([0, depth])
        plot.set_yticks([0, round(depth/2, 2),  round(depth, 2)])

        if root_loc == "top":
            plot.set_yticklabels([round(depth, 2),  round(depth/2, 2), 0])
            plot.invert_yaxis()

    return allLabels


if __name__ == '__main__':
    if len(args) == 2:
        main()
    else:
        print("\nUSAGE: python3 %s <NEWICK_STRING>" % args[0])
