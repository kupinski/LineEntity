import RealityKit
#if os(iOS)
import UIKit
#endif

#if os(macOS)
import Cocoa
#endif


#if os(macOS)
public typealias LineEntityColor = NSColor
#else
public typealias LineEntityColor = UIColor
#endif

public class LineEntity: Entity {
    public var startPos: SIMD3<Float>
    public var endPos: SIMD3<Float>
    var color: LineEntityColor
    
    private func setLine() {
        
        let anchor = AnchorEntity()
        let midPoint = (endPos + startPos) / 2.0
        anchor.position = midPoint
        
        let dir1 = normalize(endPos - startPos)
        let cosT = abs(dot(dir1, SIMD3<Float>(0,1,0)))
        if (cosT < 0.999) {
            anchor.look(at: endPos, from: midPoint, relativeTo: nil)
        } else {
            print("HERE")
            anchor.position = midPoint
        }
          
        let dist = simd_distance(startPos, endPos)
          
        var material = PhysicallyBasedMaterial()
        material.emissiveIntensity = 10000.0
        material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(color: color)

        let mesh = MeshResource.generateBox(width:0.0002,
                                            height: 0.0002,
                                            depth: dist)
          
        let entity = ModelEntity(mesh: mesh, materials: [material])
          
        anchor.addChild(entity)
        self.addChild(anchor)
    }
    
    public required init(from startP: SIMD3<Float>, to endP: SIMD3<Float>, withColor: LineEntityColor = .green) {
        self.startPos = startP
        self.endPos = endP
        self.color = withColor
        
        super.init()
        
        
        
        setLine()

    }
    
    public required convenience init() {
        self.init(from: SIMD3<Float>(0, 0, 0), to: SIMD3<Float>(Float.ulpOfOne, Float.ulpOfOne, Float.ulpOfOne))
    }
}
