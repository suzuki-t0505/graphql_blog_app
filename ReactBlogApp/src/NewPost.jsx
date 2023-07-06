import { Button, SafeAreaView, StyleSheet, Text, TextInput, View } from "react-native";
import { Header } from './Header'
import { useCallback, useState } from "react";
import { gql, useMutation } from "@apollo/client";

const CREATE_POST_MUTATION = gql`
  mutation($title: String! $body: String! $type: Int!){
    createPost(title: $title body: $body type: $type){
      id
      title
      body
      type
    }
  }
`

export const NewPost = (props) => {
  const [formState, setFormSate] = useState({
    title: '',
    body: '',
    type: 0
  });

  const changeTitle = useCallback((e) => {
    setFormSate(prevFormState => ({...prevFormState, title: e.target.value}));
  }, [formState]);

  const changeBody = useCallback((e) => {
    setFormSate(prevFormState => ({...prevFormState, body: e.target.value}));
  }, [formState]);

  const changeType = useCallback((e) => {
    const value = parseInt(e.target.value);

    if (value && value === 1 || value == 2 || value == 0) {
      setFormSate(prevFormState => ({...prevFormState, type: value}));
    } else if (e.target.value === '') {
      setFormSate(prevFormState => ({...prevFormState, type: e.target.value}));
    } else {
      setFormSate(prevFormState => ({...prevFormState, type: 0}));
    }
  }, [formState]);

  const [createPost] = useMutation(CREATE_POST_MUTATION, {
    variables: {
      title: formState.title,
      body: formState.body,
      type: formState.type
    },
    onCompleted: (test => {
      props.refetch();
      props.navigation.navigate('Home');
    })
  });

  return (
    <View>
      <Header {...props} />
      <Text>New Post</Text>
      <SafeAreaView>
        <Text style={styles.label}>Title</Text>
        <TextInput
          inputMode='text'
          style={styles.input}
          value={formState.title}
          onChange={changeTitle}
        />

        <Text style={styles.label}>Body</Text>
        <TextInput
          multiline
          numberOfLines={10}
          style={styles.multilineText}
          value={formState.body}
          onChange={changeBody}
        />

        <Text style={styles.label}>Type</Text>
        <TextInput
          inputMode='numeric'
          style={styles.input}
          value={formState.type}
          onChange={changeType}
        />

        <Button
          title='Post'
          onPress={createPost}
        />
      </SafeAreaView>
    </View>
  )
}

const styles = StyleSheet.create({
  input: {
    height: 40,
    marginHorizontal: 12,
    marginVertical: 6,
    borderWidth: 1,
    padding: 10
  },
  multilineText: {
    marginHorizontal: 12,
    marginVertical: 6,
    borderWidth: 1,
    padding: 10
  },
  label: {
    fontWeight: 'bold',
    marginLeft: 12,
    marginTop: 10
  }
});