﻿package alternativa.physics.collision
{
    import alternativa.physics.collision.types.BoundBox;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class CollisionKdTree2D
    {

        private static const nodeBoundBoxThreshold:BoundBox = new BoundBox();
        private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
        private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
        private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
        private static const _nodeBB:Vector.<Number> = new Vector.<Number>(6);
        private static const _bb:Vector.<Number> = new Vector.<Number>(6);

        public var threshold:Number = 0.1;
        public var minPrimitivesPerNode:int = 1;
        public var parentTree:CollisionKdTree;
        public var parentNode:CollisionKdNode;
        public var rootNode:CollisionKdNode;
        private var splitAxis:int;
        private var splitCost:Number;
        private var splitCoord:Number;

        public function CollisionKdTree2D(parentTree:CollisionKdTree, parentNode:CollisionKdNode)
        {
            this.parentTree = parentTree;
            this.parentNode = parentNode;
        }
        public function createTree():void
        {
            this.rootNode = new CollisionKdNode();
            this.rootNode.boundBox = this.parentNode.boundBox.clone();
            this.rootNode.indices = new Vector.<int>();
            var numObjects:int = this.parentNode.splitIndices.length;
            var i:int;
            while (i < numObjects)
            {
                this.rootNode.indices[i] = this.parentNode.splitIndices[i];
                i++;
            }
            this.splitNode(this.rootNode);
            splitCoordsX.length = (splitCoordsY.length = (splitCoordsZ.length = 0));
        }
        private function splitNode(node:CollisionKdNode):void
        {
            var objects:Vector.<int>;
            var i:int;
            var j:int;
            var nodeBoundBox:BoundBox;
            var numSplitCoordsX:int;
            var numSplitCoordsY:int;
            var numSplitCoordsZ:int;
            var bb:BoundBox;
            var min:Number = NaN;
            var max:Number = NaN;
            if (node.indices.length <= this.minPrimitivesPerNode)
            {
                return;
            }
            objects = node.indices;
            nodeBoundBox = node.boundBox;
            nodeBoundBoxThreshold.minX = (nodeBoundBox.minX + this.threshold);
            nodeBoundBoxThreshold.minY = (nodeBoundBox.minY + this.threshold);
            nodeBoundBoxThreshold.minZ = (nodeBoundBox.minZ + this.threshold);
            nodeBoundBoxThreshold.maxX = (nodeBoundBox.maxX - this.threshold);
            nodeBoundBoxThreshold.maxY = (nodeBoundBox.maxY - this.threshold);
            nodeBoundBoxThreshold.maxZ = (nodeBoundBox.maxZ - this.threshold);
            var doubleThreshold:Number = (this.threshold * 2);
            var staticBoundBoxes:Vector.<BoundBox> = this.parentTree.staticBoundBoxes;
            var numObjects:int = objects.length;
            i = 0;
            while (i < numObjects)
            {
                bb = staticBoundBoxes[objects[i]];
                if (this.parentNode.axis != 0)
                {
                    if (bb.minX > nodeBoundBoxThreshold.minX)
                    {
                        var _local_19:* = numSplitCoordsX++;
                        splitCoordsX[_local_19] = bb.minX;
                    }
                    if (bb.maxX < nodeBoundBoxThreshold.maxX)
                    {
                        _local_19 = numSplitCoordsX++;
                        splitCoordsX[_local_19] = bb.maxX;
                    }
                }
                if (this.parentNode.axis != 1)
                {
                    if (bb.minY > nodeBoundBoxThreshold.minY)
                    {
                        _local_19 = numSplitCoordsY++;
                        splitCoordsY[_local_19] = bb.minY;
                    }
                    if (bb.maxY < nodeBoundBoxThreshold.maxY)
                    {
                        _local_19 = numSplitCoordsY++;
                        splitCoordsY[_local_19] = bb.maxY;
                    }
                }
                if (this.parentNode.axis != 2)
                {
                    if (bb.minZ > nodeBoundBoxThreshold.minZ)
                    {
                        _local_19 = numSplitCoordsZ++;
                        splitCoordsZ[_local_19] = bb.minZ;
                    }
                    if (bb.maxZ < nodeBoundBoxThreshold.maxZ)
                    {
                        _local_19 = numSplitCoordsZ++;
                        splitCoordsZ[_local_19] = bb.maxZ;
                    }
                }
                i++;
            }
            this.splitAxis = -1;
            this.splitCost = 1E308;
            _nodeBB[0] = nodeBoundBox.minX;
            _nodeBB[1] = nodeBoundBox.minY;
            _nodeBB[2] = nodeBoundBox.minZ;
            _nodeBB[3] = nodeBoundBox.maxX;
            _nodeBB[4] = nodeBoundBox.maxY;
            _nodeBB[5] = nodeBoundBox.maxZ;
            if (this.parentNode.axis != 0)
            {
                this.checkNodeAxis(node, 0, numSplitCoordsX, splitCoordsX, _nodeBB);
            }
            if (this.parentNode.axis != 1)
            {
                this.checkNodeAxis(node, 1, numSplitCoordsY, splitCoordsY, _nodeBB);
            }
            if (this.parentNode.axis != 2)
            {
                this.checkNodeAxis(node, 2, numSplitCoordsZ, splitCoordsZ, _nodeBB);
            }
            if (this.splitAxis < 0)
            {
                return;
            }
            var axisX:Boolean = (this.splitAxis == 0);
            var axisY:Boolean = (this.splitAxis == 1);
            node.axis = this.splitAxis;
            node.coord = this.splitCoord;
            node.negativeNode = new CollisionKdNode();
            node.negativeNode.parent = node;
            node.negativeNode.boundBox = nodeBoundBox.clone();
            node.positiveNode = new CollisionKdNode();
            node.positiveNode.parent = node;
            node.positiveNode.boundBox = nodeBoundBox.clone();
            if (axisX)
            {
                node.negativeNode.boundBox.maxX = (node.positiveNode.boundBox.minX = this.splitCoord);
            }
            else
            {
                if (axisY)
                {
                    node.negativeNode.boundBox.maxY = (node.positiveNode.boundBox.minY = this.splitCoord);
                }
                else
                {
                    node.negativeNode.boundBox.maxZ = (node.positiveNode.boundBox.minZ = this.splitCoord);
                }
            }
            var coordMin:Number = (this.splitCoord - this.threshold);
            var coordMax:Number = (this.splitCoord + this.threshold);
            i = 0;
            while (i < numObjects)
            {
                bb = staticBoundBoxes[objects[i]];
                min = ((!(!(axisX))) ? Number(bb.minX) : ((!(!(axisY))) ? Number(bb.minY) : Number(bb.minZ)));
                max = ((!(!(axisX))) ? Number(bb.maxX) : ((!(!(axisY))) ? Number(bb.maxY) : Number(bb.maxZ)));
                if (max <= coordMax)
                {
                    if (min < coordMin)
                    {
                        if (node.negativeNode.indices == null)
                        {
                            node.negativeNode.indices = new Vector.<int>();
                        }
                        node.negativeNode.indices.push(objects[i]);
                        objects[i] = -1;
                    }
                }
                else
                {
                    if (min >= coordMin)
                    {
                        if (max > coordMax)
                        {
                            if (node.positiveNode.indices == null)
                            {
                                node.positiveNode.indices = new Vector.<int>();
                            }
                            node.positiveNode.indices.push(objects[i]);
                            objects[i] = -1;
                        }
                    }
                }
                i++;
            }
            i = 0;
            j = 0;
            while (i < numObjects)
            {
                if (objects[i] >= 0)
                {
                    _local_19 = j++;
                    objects[_local_19] = objects[i];
                }
                i++;
            }
            if (j > 0)
            {
                objects.length = j;
            }
            else
            {
                node.indices = null;
            }
            if (node.negativeNode.indices != null)
            {
                this.splitNode(node.negativeNode);
            }
            if (node.positiveNode.indices != null)
            {
                this.splitNode(node.positiveNode);
            }
        }
        private function checkNodeAxis(node:CollisionKdNode, axis:int, numSplitCoords:int, splitCoords:Vector.<Number>, bb:Vector.<Number>):void
        {
            var currSplitCoord:Number = NaN;
            var minCoord:Number = NaN;
            var maxCoord:Number = NaN;
            var areaNegative:Number = NaN;
            var areaPositive:Number = NaN;
            var numNegative:int;
            var numPositive:int;
            var conflict:Boolean;
            var numObjects:int;
            var j:int;
            var cost:Number = NaN;
            var boundBox:BoundBox;
            var axis1:int = ((axis + 1) % 3);
            var axis2:int = ((axis + 2) % 3);
            var area:Number = ((bb[(axis1 + 3)] - bb[axis1]) * (bb[(axis2 + 3)] - bb[axis2]));
            var staticBoundBoxes:Vector.<BoundBox> = this.parentTree.staticBoundBoxes;
            var i:int;
            while (i < numSplitCoords)
            {
                currSplitCoord = splitCoords[i];
                if ((!(isNaN(currSplitCoord))))
                {
                    minCoord = (currSplitCoord - this.threshold);
                    maxCoord = (currSplitCoord + this.threshold);
                    areaNegative = (area * (currSplitCoord - bb[axis]));
                    areaPositive = (area * (bb[int((axis + 3))] - currSplitCoord));
                    numNegative = 0;
                    numPositive = 0;
                    conflict = false;
                    numObjects = node.indices.length;
                    j = 0;
                    while (j < numObjects)
                    {
                        boundBox = staticBoundBoxes[node.indices[j]];
                        _bb[0] = boundBox.minX;
                        _bb[1] = boundBox.minY;
                        _bb[2] = boundBox.minZ;
                        _bb[3] = boundBox.maxX;
                        _bb[4] = boundBox.maxY;
                        _bb[5] = boundBox.maxZ;
                        if (_bb[(axis + 3)] <= maxCoord)
                        {
                            if (_bb[axis] < minCoord)
                            {
                                numNegative++;
                            }
                        }
                        else
                        {
                            if (_bb[axis] >= minCoord)
                            {
                                numPositive++;
                            }
                            else
                            {
                                conflict = true;
                                break;
                            }
                        }
                        j++;
                    }
                    cost = ((areaNegative * numNegative) + (areaPositive * numPositive));
                    if (((!(conflict)) && (cost < this.splitCost)))
                    {
                        this.splitAxis = axis;
                        this.splitCost = cost;
                        this.splitCoord = currSplitCoord;
                    }
                    j = (i + 1);
                    while (j < numSplitCoords)
                    {
                        if (((splitCoords[j] >= (currSplitCoord - this.threshold)) && (splitCoords[j] <= (currSplitCoord + this.threshold))))
                        {
                            splitCoords[j] = NaN;
                        }
                        j++;
                    }
                }
                i++;
            }
        }

    }
}
