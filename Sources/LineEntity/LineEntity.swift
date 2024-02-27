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
    public var startPos: SIMD3<Float> {
        didSet {
            setLine()
        }
    }
    public var endPos: SIMD3<Float> {
        didSet {
            setLine()
        }
    }
    public var color: LineEntityColor {
        didSet {
            setLine()
        }
    }
    
    public var scaleThickness: Float {
        didSet {
            setLine()
        }
    }
    
    private func setLine() {
        if !children.isEmpty {
            children.removeAll()
        }
        
        let anchor = Entity()
        let midPoint = (endPos + startPos) / 2.0
        anchor.position = midPoint
        
        let dir1 = normalize(endPos - startPos)
        let cosT = abs(dot(dir1, SIMD3<Float>(0,1,0)))
        
        if (cosT < 0.9999) {
            anchor.look(at: endPos, from: midPoint, relativeTo: nil)
        } else {
            anchor.transform = Transform(pitch: Float.pi / 2.0, yaw: 0.0, roll: 0.0)
            anchor.position = midPoint
        }
          
        let dist = simd_distance(startPos, endPos)
          
        var material = PhysicallyBasedMaterial()
        material.emissiveIntensity = 10000.0
        material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(color: color)

        let mesh = MeshResource.generateBox(width:0.0002 * scaleThickness,
                                            height: 0.0002 * scaleThickness,
                                            depth: dist)
          
        let entity = ModelEntity(mesh: mesh, materials: [material])
          
        anchor.addChild(entity)
        self.addChild(anchor)
    }
    
    public required init(from startP: SIMD3<Float>, to endP: SIMD3<Float>, withColor: LineEntityColor = .green, scaleThickness: Float = 1.0) {
        self.startPos = startP
        self.endPos = endP
        self.color = withColor
        self.scaleThickness = scaleThickness
        
        super.init()
        
        
        
        setLine()

    }
    
    public required convenience init() {
        self.init(from: SIMD3<Float>(0, 0, 0), to: SIMD3<Float>(Float.ulpOfOne, Float.ulpOfOne, Float.ulpOfOne))
    }
}
