var Module = { 
	onRuntimeInitialized: function () {
		MONO.mono_load_runtime_and_bcl (
			"managed",
			"managed",
			1,
			[ "Fusee.Base.Common.dll", "Fusee.Base.Core.dll", "Fusee.Base.Imp.WebAsm.dll", "Fusee.Engine.Common.dll", "Fusee.Engine.Core.dll", "Fusee.Engine.GUI.dll", "Fusee.Engine.Imp.Graphics.WebAsm.dll", "Fusee.Examples.Picking.Core.dll", "Fusee.Examples.Picking.WebAsm.dll", "Fusee.Jometri.dll", "Fusee.Math.Core.dll", "Fusee.Serialization.dll", "Fusee.SerializationSerializer.dll", "Fusee.Xene.dll", "Fusee.Xirkit.dll", "Mono.Security.dll", "mscorlib.dll", "netstandard.dll", "protobuf-net.dll", "SharpFont_mngd.dll", "SkiaSharp.Wasm.dll", "System.Core.dll", "System.dll", "System.Drawing.Common.dll", "System.Net.Http.dll", "System.Numerics.dll", "System.Runtime.Serialization.dll", "System.ServiceModel.Internals.dll", "System.Xml.dll", "WebAssembly.Bindings.dll", "WebAssembly.Net.Http.dll", "WebAssembly.Net.WebSockets.dll", "Fusee.Base.Common.pdb", "Fusee.Base.Core.pdb", "Fusee.Base.Imp.WebAsm.pdb", "Fusee.Engine.Common.pdb", "Fusee.Engine.Core.pdb", "Fusee.Engine.GUI.pdb", "Fusee.Engine.Imp.Graphics.WebAsm.pdb", "Fusee.Examples.Picking.Core.pdb", "Fusee.Examples.Picking.WebAsm.pdb", "Fusee.Jometri.pdb", "Fusee.Math.Core.pdb", "Fusee.Serialization.pdb", "Fusee.Xene.pdb", "Fusee.Xirkit.pdb", "Mono.Security.pdb", "mscorlib.pdb", "SharpFont_mngd.pdb", "System.Core.pdb", "System.Drawing.Common.pdb", "System.Net.Http.pdb", "System.Numerics.pdb", "System.pdb", "System.Runtime.Serialization.pdb", "System.ServiceModel.Internals.pdb", "System.Xml.pdb", "WebAssembly.Bindings.pdb", "WebAssembly.Net.Http.pdb", "WebAssembly.Net.WebSockets.pdb" ],
			function () {
				App.init ();
			}
		);
	},
};


