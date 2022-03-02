//
//  SystemMisc.swift
//  fall-detector
//
//  Created by Harry Wixley on 02/03/2022.
//

import Foundation

public class SystemMisc {

   /// Wrapper for the memcpy() method that allows specification of an offset for the destination
   /// and/or the source addresses.
   ///
   /// This version for when destination is a normal Swift byte array.
   ///
   /// - Parameters:
   ///   - destPointer:    Address for destination byte array, typically Swift [UInt8].
   ///   - destOffset:     Offset to be added to the destination address, may be zero.
   ///   - sourcePointer:  Address for source byte array, typically Swift [UInt8].
   ///   - sourceOffset:   Offset to be added to the source address, may be zero.
   ///   - byteLength:     Number of bytes to be copied.
   public static func memoryCopy(_ destPointer : UnsafeRawPointer, _ destOffset : Int,
                                 _ sourcePointer : UnsafeRawPointer, _ sourceOffset : Int,
                                 _ byteLength : Int) {

      memoryCopy(UnsafeMutableRawPointer(mutating: destPointer), destOffset,
                 sourcePointer, sourceOffset, byteLength)
   }


   /// Wrapper for the memcpy() method that allows specification of an offset for the destination
   /// and/or the source addresses.
   ///
   /// This version for when destination address is already available as an UnsafeMutableRawPointer,
   /// for example if caller has used UnsafeMutableRawPointer() to create it or is working with
   /// unmanaged memory. The destPointer argument may also be a converted pointer, as done by the
   /// above wrapper method.
   ///
   /// - Parameters:
   ///   - destPointer:    Address for destination byte array, see above notes.
   ///   - destOffset:     Offset to be added to the destination address, may be zero.
   ///   - sourcePointer:  Address for source byte array, typically Swift [UInt8].
   ///   - sourceOffset:   Offset to be added to the source address, may be zero.
   ///   - byteLength:     Number of bytes to be copied.
   public static func memoryCopy(_ destPointer : UnsafeMutableRawPointer, _ destOffset : Int,
                                 _ sourcePointer : UnsafeRawPointer, _ sourceOffset : Int,
                                 _ byteLength : Int) {

      memcpy(destPointer.advanced(by: destOffset),
             sourcePointer.advanced(by: sourceOffset),
             byteLength)
   }
}
