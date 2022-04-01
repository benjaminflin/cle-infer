module CLE.Infer.Monad where


import Control.Monad.Trans.RWS
import CLE.JSON.Model (CLEMap(..), Label (Label), CDF (CDF), Definition)
import CLE.Infer.Constraint
import qualified Data.Map as M
import Data.Coerce (coerce)
import Control.Monad.Trans.Class (lift)


data CheckErr
    = NotFunctionAnnotation Label 
    | LabelLookupFailure Label
    | LookupFailure QName
    | NoCdf String
    | NoTaints CDF
    | Other String
    deriving (Show, Eq)

type Check = RWST CLEMap [Constraint] Int (Either CheckErr)

fresh :: Check Ty
fresh = do
    i <- get
    put (i + 1)
    pure $ UniVar i

throw :: CheckErr -> Check a 
throw = lift . Left

toType :: Maybe Label -> Check Ty
toType (Just x) = pure $ Labelled x
toType Nothing = fresh

lookupLabel :: Label -> Check Definition    
lookupLabel lbl = do
    maybeDef <- asks (M.lookup lbl . unwrap) 
    case maybeDef of
        Just def -> pure def
        Nothing -> throw $ LabelLookupFailure lbl   
    where
        unwrap :: CLEMap -> M.Map Label Definition
        unwrap (CLEMap m) = m

emitConstraint :: Constraint -> Check () 
emitConstraint x = tell [x] 

lookupName :: QName -> M.Map QName Ty -> Check Ty
lookupName name map =
    case M.lookup name map of
        Just ty -> pure ty
        Nothing -> throw $ LookupFailure name