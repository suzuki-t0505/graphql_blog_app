import { AuthForm } from "./AuthForm";
import { Button, View, SafeAreaView } from "react-native";
import { Header } from "./Header";
import { useAuthMutation } from "./hooks/useAuthMutation";

export const Register = (props) => {
  const { formState, setFormState, register } = useAuthMutation(props.saveAuthToken, props.navigation);
  
  return (
    <View>
      <Header {...props} />
      <SafeAreaView>
        <AuthForm formState={formState} setFormState={setFormState} />
        <Button
          title='Register'
          onPress={register}
        />
      </SafeAreaView>
    </View>
  )
};
