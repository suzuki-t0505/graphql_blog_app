import { View } from 'react-native'
import { Header } from './components/Header'
import { AuthForm } from './components/AuthForm';


export const Login = () => {
  return (
    <View>
      <Header />
      <AuthForm type="login" />
    </View>
  )
};
