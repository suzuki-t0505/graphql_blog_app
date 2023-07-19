import { AuthForm } from "./components/AuthForm";
import { View } from "react-native";
import { Header } from "./components/Header";

export const Register = () => {
  return (
    <View>
      <Header />
      <AuthForm type="register" />
    </View>
  )
};
