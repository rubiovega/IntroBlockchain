// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract lab6ex6 {
    uint[] public arr;

    function generate(uint n) external {
        // Populates the array with some weird small numbers.
        bytes32 b = keccak256("seed");
        
        for (uint i = 0; i < n; i++) {
            uint8 number = uint8(b[i % 32]);
            arr.push(number);
        }
    }

    function maxMinStorage() public view returns (uint maxmin) {
        assembly {

            function fmaxmin(slot) -> maxVal, minVal {
                mstore(0x0, slot)

                let dataAddress := keccak256(0x0, 0x20)
                let len := sload(slot)
                maxVal := sload(dataAddress)
                minVal := sload(dataAddress)
                
                let i := 1
                for {} lt(i,len) {i:= add(i,1)}
                    {
                        let elem := sload(add(dataAddress,i))
                        if gt(elem,maxVal) { maxVal := elem }
                        if lt(elem,minVal) { minVal := elem }
                    }
                }
            let max, min := fmaxmin(arr.slot)
            maxmin := sub(max,min)                     
            }

  
        }    
}

contract lab6ex7 {
    uint[] public arr;

    function generate(uint n) external {
        // Populates the array with some weird small numbers.
        bytes32 b = keccak256("seed");
        
        for (uint i = 0; i < n; i++) {
            uint8 number = uint8(b[i % 32]);
            arr.push(number);
        }
    }

    function maxMinStorage() external view returns (uint maxmin) {
        uint i = 0;
        uint max = arr[i];
        uint min = arr[i];

        while(i < arr.length) {
            if(max<arr[i]){
                max= arr[i];
            } 

            if(min>arr[i]){
                min = arr[i];
            } 
            
            i++;
        }
        return max-min;
    }

}