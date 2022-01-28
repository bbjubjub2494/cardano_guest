{ system
  , compiler
  , flags
  , pkgs
  , hsPkgs
  , pkgconfPkgs
  , errorHandler
  , config
  , ... }:
  {
    flags = {
      ghci = false;
      terminfo = true;
      stage1 = false;
      stage2 = true;
      stage3 = false;
      dynamic-system-linker = true;
      };
    package = {
      specVersion = "1.10";
      identifier = { name = "ghc"; version = "8.6.5"; };
      license = "BSD-3-Clause";
      copyright = "";
      maintainer = "glasgow-haskell-users@haskell.org";
      author = "The GHC Team";
      homepage = "http://www.haskell.org/ghc/";
      url = "";
      synopsis = "The GHC API";
      description = "GHC's functionality can be useful for more things than just\ncompiling Haskell programs. Important use cases are programs\nthat analyse (and perhaps transform) Haskell code. Others\ninclude loading Haskell code dynamically in a GHCi-like manner.\nFor this reason, a lot of GHC's functionality is made available\nthrough this package.";
      buildType = "Simple";
      isLocal = true;
      detailLevel = "FullDetails";
      licenseFiles = [ "LICENSE" ];
      dataDir = ".";
      dataFiles = [];
      extraSrcFiles = [
        "utils/md5.h"
        "Unique.h"
        "nativeGen/NCG.h"
        "parser/cutils.h"
        ];
      extraTmpFiles = [];
      extraDocFiles = [];
      };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
          (hsPkgs."directory" or (errorHandler.buildDepError "directory"))
          (hsPkgs."process" or (errorHandler.buildDepError "process"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
          (hsPkgs."time" or (errorHandler.buildDepError "time"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."array" or (errorHandler.buildDepError "array"))
          (hsPkgs."filepath" or (errorHandler.buildDepError "filepath"))
          (hsPkgs."template-haskell" or (errorHandler.buildDepError "template-haskell"))
          (hsPkgs."hpc" or (errorHandler.buildDepError "hpc"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."ghc-boot" or (errorHandler.buildDepError "ghc-boot"))
          (hsPkgs."ghc-boot-th" or (errorHandler.buildDepError "ghc-boot-th"))
          (hsPkgs."ghc-heap" or (errorHandler.buildDepError "ghc-heap"))
          (hsPkgs."ghci" or (errorHandler.buildDepError "ghci"))
          ] ++ (if system.isWindows
          then [ (hsPkgs."Win32" or (errorHandler.buildDepError "Win32")) ]
          else [
            (hsPkgs."unix" or (errorHandler.buildDepError "unix"))
            ] ++ (pkgs.lib).optional (flags.terminfo) (hsPkgs."terminfo" or (errorHandler.buildDepError "terminfo")));
        build-tools = [
          (hsPkgs.buildPackages.alex.components.exes.alex or (pkgs.buildPackages.alex or (errorHandler.buildToolDepError "alex:alex")))
          (hsPkgs.buildPackages.happy.components.exes.happy or (pkgs.buildPackages.happy or (errorHandler.buildToolDepError "happy:happy")))
          ];
        buildable = true;
        modules = [
          "GhcPrelude"
          "Ar"
          "FileCleanup"
          "DriverBkp"
          "BkpSyn"
          "NameShape"
          "RnModIface"
          "Avail"
          "AsmUtils"
          "BasicTypes"
          "ConLike"
          "DataCon"
          "PatSyn"
          "Demand"
          "Debug"
          "Exception"
          "FieldLabel"
          "GhcMonad"
          "Hooks"
          "Id"
          "IdInfo"
          "Lexeme"
          "Literal"
          "Llvm"
          "Llvm/AbsSyn"
          "Llvm/MetaData"
          "Llvm/PpLlvm"
          "Llvm/Types"
          "LlvmCodeGen"
          "LlvmCodeGen/Base"
          "LlvmCodeGen/CodeGen"
          "LlvmCodeGen/Data"
          "LlvmCodeGen/Ppr"
          "LlvmCodeGen/Regs"
          "LlvmMangler"
          "MkId"
          "Module"
          "Name"
          "NameEnv"
          "NameSet"
          "OccName"
          "RdrName"
          "NameCache"
          "SrcLoc"
          "UniqSupply"
          "Unique"
          "Var"
          "VarEnv"
          "VarSet"
          "UnVarGraph"
          "BlockId"
          "CLabel"
          "Cmm"
          "CmmBuildInfoTables"
          "CmmPipeline"
          "CmmCallConv"
          "CmmCommonBlockElim"
          "CmmImplementSwitchPlans"
          "CmmContFlowOpt"
          "CmmExpr"
          "CmmInfo"
          "CmmLex"
          "CmmLint"
          "CmmLive"
          "CmmMachOp"
          "CmmMonad"
          "CmmSwitch"
          "CmmNode"
          "CmmOpt"
          "CmmParse"
          "CmmProcPoint"
          "CmmSink"
          "CmmType"
          "CmmUtils"
          "CmmLayoutStack"
          "EnumSet"
          "MkGraph"
          "PprBase"
          "PprC"
          "PprCmm"
          "PprCmmDecl"
          "PprCmmExpr"
          "Bitmap"
          "CodeGen/Platform"
          "CodeGen/Platform/ARM"
          "CodeGen/Platform/ARM64"
          "CodeGen/Platform/NoRegs"
          "CodeGen/Platform/PPC"
          "CodeGen/Platform/PPC_Darwin"
          "CodeGen/Platform/SPARC"
          "CodeGen/Platform/X86"
          "CodeGen/Platform/X86_64"
          "CgUtils"
          "StgCmm"
          "StgCmmBind"
          "StgCmmClosure"
          "StgCmmCon"
          "StgCmmEnv"
          "StgCmmExpr"
          "StgCmmForeign"
          "StgCmmHeap"
          "StgCmmHpc"
          "StgCmmArgRep"
          "StgCmmLayout"
          "StgCmmMonad"
          "StgCmmPrim"
          "StgCmmProf"
          "StgCmmTicky"
          "StgCmmUtils"
          "StgCmmExtCode"
          "SMRep"
          "CoreArity"
          "CoreFVs"
          "CoreLint"
          "CorePrep"
          "CoreSubst"
          "CoreOpt"
          "CoreSyn"
          "TrieMap"
          "CoreTidy"
          "CoreUnfold"
          "CoreUtils"
          "CoreMap"
          "CoreSeq"
          "CoreStats"
          "MkCore"
          "PprCore"
          "PmExpr"
          "TmOracle"
          "Check"
          "Coverage"
          "Desugar"
          "DsArrows"
          "DsBinds"
          "DsCCall"
          "DsExpr"
          "DsForeign"
          "DsGRHSs"
          "DsListComp"
          "DsMonad"
          "DsUsage"
          "DsUtils"
          "ExtractDocs"
          "Match"
          "MatchCon"
          "MatchLit"
          "HsBinds"
          "HsDecls"
          "HsDoc"
          "HsExpr"
          "HsImpExp"
          "HsLit"
          "PlaceHolder"
          "HsExtension"
          "HsInstances"
          "HsPat"
          "HsSyn"
          "HsTypes"
          "HsUtils"
          "HsDumpAst"
          "BinIface"
          "BinFingerprint"
          "BuildTyCl"
          "IfaceEnv"
          "IfaceSyn"
          "IfaceType"
          "ToIface"
          "LoadIface"
          "MkIface"
          "TcIface"
          "FlagChecker"
          "Annotations"
          "CmdLineParser"
          "CodeOutput"
          "Config"
          "Constants"
          "DriverMkDepend"
          "DriverPhases"
          "PipelineMonad"
          "DriverPipeline"
          "DynFlags"
          "ErrUtils"
          "Finder"
          "GHC"
          "GhcMake"
          "GhcPlugins"
          "DynamicLoading"
          "HeaderInfo"
          "HscMain"
          "HscStats"
          "HscTypes"
          "InteractiveEval"
          "InteractiveEvalTypes"
          "PackageConfig"
          "Packages"
          "PlatformConstants"
          "Plugins"
          "TcPluginM"
          "PprTyThing"
          "StaticPtrTable"
          "SysTools"
          "SysTools/BaseDir"
          "SysTools/Terminal"
          "SysTools/ExtraObj"
          "SysTools/Info"
          "SysTools/Process"
          "SysTools/Tasks"
          "Elf"
          "TidyPgm"
          "Ctype"
          "HaddockUtils"
          "Lexer"
          "OptCoercion"
          "Parser"
          "RdrHsSyn"
          "ApiAnnotation"
          "ForeignCall"
          "KnownUniques"
          "PrelInfo"
          "PrelNames"
          "PrelRules"
          "PrimOp"
          "TysPrim"
          "TysWiredIn"
          "CostCentre"
          "CostCentreState"
          "ProfInit"
          "RnBinds"
          "RnEnv"
          "RnExpr"
          "RnHsDoc"
          "RnNames"
          "RnPat"
          "RnSource"
          "RnSplice"
          "RnTypes"
          "RnFixity"
          "RnUtils"
          "RnUnbound"
          "CoreMonad"
          "CSE"
          "FloatIn"
          "FloatOut"
          "LiberateCase"
          "OccurAnal"
          "SAT"
          "SetLevels"
          "SimplCore"
          "SimplEnv"
          "SimplMonad"
          "SimplUtils"
          "Simplify"
          "SimplStg"
          "StgStats"
          "StgCse"
          "UnariseStg"
          "RepType"
          "Rules"
          "SpecConstr"
          "Specialise"
          "CoreToStg"
          "StgLint"
          "StgSyn"
          "CallArity"
          "DmdAnal"
          "Exitify"
          "WorkWrap"
          "WwLib"
          "FamInst"
          "Inst"
          "TcAnnotations"
          "TcArrows"
          "TcBinds"
          "TcSigs"
          "TcClassDcl"
          "TcDefaults"
          "TcDeriv"
          "TcDerivInfer"
          "TcDerivUtils"
          "TcEnv"
          "TcExpr"
          "TcForeign"
          "TcGenDeriv"
          "TcGenFunctor"
          "TcGenGenerics"
          "TcHsSyn"
          "TcHsType"
          "TcInstDcls"
          "TcMType"
          "TcValidity"
          "TcMatches"
          "TcPat"
          "TcPatSyn"
          "TcRnDriver"
          "TcBackpack"
          "TcRnExports"
          "TcRnMonad"
          "TcRnTypes"
          "TcRules"
          "TcSimplify"
          "TcHoleErrors"
          "TcErrors"
          "TcTyClsDecls"
          "TcTyDecls"
          "TcTypeable"
          "TcType"
          "TcEvidence"
          "TcEvTerm"
          "TcUnify"
          "TcInteract"
          "TcCanonical"
          "TcFlatten"
          "TcSMonad"
          "TcTypeNats"
          "TcSplice"
          "Class"
          "Coercion"
          "DsMeta"
          "THNames"
          "FamInstEnv"
          "FunDeps"
          "InstEnv"
          "TyCon"
          "CoAxiom"
          "Kind"
          "Type"
          "TyCoRep"
          "Unify"
          "Bag"
          "Binary"
          "BooleanFormula"
          "BufWrite"
          "Digraph"
          "Encoding"
          "FastFunctions"
          "FastMutInt"
          "FastString"
          "FastStringEnv"
          "Fingerprint"
          "FiniteMap"
          "FV"
          "GraphBase"
          "GraphColor"
          "GraphOps"
          "GraphPpr"
          "IOEnv"
          "Json"
          "ListSetOps"
          "ListT"
          "Maybes"
          "MonadUtils"
          "OrdList"
          "Outputable"
          "Pair"
          "Panic"
          "PprColour"
          "Pretty"
          "State"
          "Stream"
          "StringBuffer"
          "UniqDFM"
          "UniqDSet"
          "UniqFM"
          "UniqMap"
          "UniqSet"
          "Util"
          "Hoopl/Block"
          "Hoopl/Collections"
          "Hoopl/Dataflow"
          "Hoopl/Graph"
          "Hoopl/Label"
          "AsmCodeGen"
          "TargetReg"
          "NCGMonad"
          "Instruction"
          "Format"
          "Reg"
          "RegClass"
          "PIC"
          "Platform"
          "CPrim"
          "X86/Regs"
          "X86/RegInfo"
          "X86/Instr"
          "X86/Cond"
          "X86/Ppr"
          "X86/CodeGen"
          "PPC/Regs"
          "PPC/RegInfo"
          "PPC/Instr"
          "PPC/Cond"
          "PPC/Ppr"
          "PPC/CodeGen"
          "SPARC/Base"
          "SPARC/Regs"
          "SPARC/Imm"
          "SPARC/AddrMode"
          "SPARC/Cond"
          "SPARC/Instr"
          "SPARC/Stack"
          "SPARC/ShortcutJump"
          "SPARC/Ppr"
          "SPARC/CodeGen"
          "SPARC/CodeGen/Amode"
          "SPARC/CodeGen/Base"
          "SPARC/CodeGen/CondCode"
          "SPARC/CodeGen/Gen32"
          "SPARC/CodeGen/Gen64"
          "SPARC/CodeGen/Sanity"
          "SPARC/CodeGen/Expand"
          "RegAlloc/Liveness"
          "RegAlloc/Graph/Main"
          "RegAlloc/Graph/Stats"
          "RegAlloc/Graph/ArchBase"
          "RegAlloc/Graph/ArchX86"
          "RegAlloc/Graph/Coalesce"
          "RegAlloc/Graph/Spill"
          "RegAlloc/Graph/SpillClean"
          "RegAlloc/Graph/SpillCost"
          "RegAlloc/Graph/TrivColorable"
          "RegAlloc/Linear/Main"
          "RegAlloc/Linear/JoinToTargets"
          "RegAlloc/Linear/State"
          "RegAlloc/Linear/Stats"
          "RegAlloc/Linear/FreeRegs"
          "RegAlloc/Linear/StackMap"
          "RegAlloc/Linear/Base"
          "RegAlloc/Linear/X86/FreeRegs"
          "RegAlloc/Linear/X86_64/FreeRegs"
          "RegAlloc/Linear/PPC/FreeRegs"
          "RegAlloc/Linear/SPARC/FreeRegs"
          "Dwarf"
          "Dwarf/Types"
          "Dwarf/Constants"
          "Convert"
          "ByteCodeTypes"
          "ByteCodeAsm"
          "ByteCodeGen"
          "ByteCodeInstr"
          "ByteCodeItbls"
          "ByteCodeLink"
          "Debugger"
          "Linker"
          "RtClosureInspect"
          "GHCi"
          ];
        cSources = [
          "parser/cutils.c"
          "ghci/keepCAFsForGHCi.c"
          "cbits/genSym.c"
          ];
        hsSourceDirs = [
          "backpack"
          "basicTypes"
          "cmm"
          "codeGen"
          "coreSyn"
          "deSugar"
          "ghci"
          "hsSyn"
          "iface"
          "llvmGen"
          "main"
          "nativeGen"
          "parser"
          "prelude"
          "profiling"
          "rename"
          "simplCore"
          "simplStg"
          "specialise"
          "stgSyn"
          "stranal"
          "typecheck"
          "types"
          "utils"
          ];
        includeDirs = [
          "."
          "parser"
          "utils"
          ] ++ (pkgs.lib).optional (flags.ghci) "../rts/dist/build";
        };
      };
    } // rec { src = (pkgs.lib).mkDefault ../compiler; }