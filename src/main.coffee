map = require('./test.js')

theta = phi = 0

scene = new THREE.Scene()
scene.fog = new THREE.Fog 0x222222, 0.015, 6000
camera = new THREE.PerspectiveCamera 35, window.innerWidth / window.innerHeight, 0.1, 5000
camera.position.x = 2000
camera.position.y = 600
camera.position.z = 2000
camera.lookAt scene.position
scene.add camera

renderer = new THREE.WebGLRenderer { alpha: true, antialias: true }
renderer.setClearColor new THREE.Color 0x222222, 1.0
renderer.setSize window.innerWidth, window.innerHeight
renderer.shadowMap.enabled = true
renderer.shadowMap.type = THREE.PCFSoftShadowMap
document.getElementById("WebGL-output").appendChild renderer.domElement

mapMaterial = new THREE.LineBasicMaterial { color: 0xededed }
counter = 0
for segment in map.allPaths
    lineGeometry = new THREE.Geometry()
    for point in segment
        lineGeometry.vertices.push new THREE.Vector3(point[0], point[1], point[2])
    mapMaterial = new THREE.LineBasicMaterial { color: new THREE.Color point[1] / 100, point[1] / 100, point[1] / 100 }
    line = new THREE.Line lineGeometry, mapMaterial
    scene.add line
    console.log ++counter
console.log "DONE"

axes = new THREE.AxisHelper 500
scene.add axes

ambientLight = new THREE.AmbientLight 0x00020c
scene.add ambientLight

spotLight = new THREE.SpotLight 0xffffff
spotLight.position.set -40, 60, -10
spotLight.castShadow = true
scene.add spotLight

render = () ->
    x = 2000 * Math.sin(theta)
    z = 2000 * Math.cos(theta)
    camera.position.x = 3500 + x
    # camera.position.y = 100 * Math.sin(phi) * Math.sin(phi) + 500
    camera.position.z = 2000 + z
    camera.lookAt new THREE.Vector3(3500 + x * .5, 0, 2000 + z * .5)
    theta += 0.002
    # phi += 0.0765

    requestAnimationFrame render
    renderer.render scene, camera
    return

render()

window.onresize = () ->
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight
    return



