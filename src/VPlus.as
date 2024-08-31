package
{
    public class VPlus
    {
        static public function deleteAt(V:*, index:int):void
        {
            // The method cuts a portion of Vector and returns it.
            // We need just the "cut" part, yet it suffices.
            V.splice(index, 1);
        }

        static public function insertAt(V:*, index:int, element:*):void
        {
            // Fix for from-the-end-and-backwards indexing.
            if (index < 0)
            {
                index = V.length - index;
            }

            // Add one more element to the end of the given Vector.
            V.push(null);

            // Shift the Vector's elements from index and on.
            for (var i:int = V.length - 2; i >= index; i--)
            {
                V[i + 1] = V[i];
            }

            // Put the new element to its designated place.
            V[index] = element;
        }
    }
}