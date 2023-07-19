import renderer from 'react-test-renderer';

// import App from '../App';
import { PostCard } from '../src/components/PostCard'

describe('<PostCard />', () => {
  it('has 1 child', () => {
    post = {
      account: {email: 'test@sample.com'},
      title: 'test',
      submitDatetime: '2023-07-01',
      id: '1'
    }
    
    const tree = renderer.create(<PostCard key={post.id} post={post} />).toJSON();

    expect(tree.children.length).toBe(3)
  })
})

// describe('<App />', () => {
//   it('has 1 child', () => {
//     const tree = renderer.create(<App />).toJSON();

//     expect(tree.children.length).toBe(1);
//   })
// })