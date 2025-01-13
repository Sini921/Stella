import Foundation

guard let makefileContent = try? String(contentsOfFile: "./Tweak/Makefile", encoding: .utf8) else {
    fatalError("Failed to read Makefile")
}

guard let tweakNameLine = makefileContent.split(separator: "\n").first(where: { $0.hasPrefix("TWEAK_NAME") }) else {
    fatalError("Tweak name not found in Makefile")
}

let tweakName = tweakNameLine.replacingOccurrences(of: "TWEAK_NAME = ", with: "").trimmingCharacters(in: .whitespaces)

let outputFilePath = "./Preferences/Sources/\(tweakName)Preferences/Constants.swift"

guard let controlFileContent = try? String(contentsOfFile: "./control", encoding: .utf8) else {
    fatalError("Failed to read control file")
}

let versionPrefix = "Version: "
guard let versionLine = controlFileContent.split(separator: "\n").first(where: { $0.hasPrefix(versionPrefix) }) else {
    fatalError("Version not found in control file")
}

let versionNumber = versionLine.replacingOccurrences(of: versionPrefix, with: "").trimmingCharacters(in: .whitespaces)

print("Version number: \(versionNumber)")

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
let currentDate = dateFormatter.string(from: Date())

let constantsContent = """
// This file was automatically generated during the build process by generate_version.swift on \(currentDate)

import Foundation

internal struct Constants {
    static let versionNumber = "\(versionNumber)"
    static let social = "@yandevelop"
}
"""

do {
    try constantsContent.write(toFile: outputFilePath, atomically: true, encoding: .utf8)
    print("Constants.swift file generated successfully at \(currentDate)")
} catch {
    fatalError("Failed to write Constants.swift file: \(error)")
}