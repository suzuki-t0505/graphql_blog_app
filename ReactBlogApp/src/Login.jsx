import { View, SafeAreaView, Button } from 'react-native'
import { Header } from './Header'
import { AuthForm } from './AuthForm';
import { useAuthMutation } from './hooks/useAuthMutation';


export const Login = (props) => {
  const { formState, setFormState, login } =  useAuthMutation(props.saveAuthToken, props.navigation);

  return (
    <View>
      <Header {...props} />
      <SafeAreaView>
        <AuthForm formState={formState} setFormState={setFormState} />
        <Button
          title='Login'
          onPress={login}
        />
      </SafeAreaView>
    </View>
  )
};
