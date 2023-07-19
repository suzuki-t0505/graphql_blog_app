import { createContext, useContext } from "react";

const NavigationContext = createContext(null);

export const Navigation = ({ navigation, children}) => {
  return (
    <NavigationContext.Provider value={navigation}>
      { children }
    </NavigationContext.Provider>
  )
};

export const useNavigation = () => useContext(NavigationContext);