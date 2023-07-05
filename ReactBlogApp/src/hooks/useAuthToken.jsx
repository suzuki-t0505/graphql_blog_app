import AsyncStorage from "@react-native-async-storage/async-storage";
import { useCallback, useState } from "react"
import { AUTH_TOKEN } from "../constants";


export const useAuthToken = () => {
  const [authToken, setAuthToken] = useState('');

  const getAuthToken = useCallback(async () => {
    try {
      await AsyncStorage.getItem(AUTH_TOKEN).then(value => setAuthToken(value));
    } catch (e) {
      console.error(e);
    }
  }, [authToken]);

  const saveAuthToken = useCallback((token) => {
    if (token) {
      AsyncStorage.setItem(AUTH_TOKEN, token);
      getAuthToken();
    } else {
      console.error('no token');
    }
  }, [authToken]);

  const deleteAuthToken = useCallback(() => {
    if (authToken){
      AsyncStorage.removeItem(AUTH_TOKEN)
      getAuthToken();
    } else {
      console.error('no token')
    }
  }, [authToken]);

  return { authToken, setAuthToken, getAuthToken, saveAuthToken, deleteAuthToken }
}